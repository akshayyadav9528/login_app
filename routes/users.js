const express = require('express');
const mongoose = require('mongoose');
const _ = require('lodash');
const bcrypt = require('bcrypt');
const { User, validateuser } = require('../models/user');
const auth = require('../middleware/auth');
const app = express.Router();
const joi = require('joi');

// ✅ CREATE ACCOUNT
app.post('/create', async (req, res) => {
  const { error } = validateuser(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });

  let user = await User.findOne({ email: req.body.email });
  if (user) return res.status(400).json({ message: 'User already registered.' });

  user = new User(_.pick(req.body, ['firstName', 'lastName', 'email', 'password']));

  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  await user.save();

  const token = user.generateauthtoken();
  return res.header('x-auth-token', token).json({ message: 'User created successfully' });
});

// ✅ LOGIN
function validateLogin(req) {
  const schema = joi.object({
    email: joi.string().email().required(),
    password: joi.string().min(8).max(16).required(),
  });
  return schema.validate(req);
}

app.post('/login', async (req, res) => {
  const { error } = validateLogin(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });

  let user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(400).json({ message: 'Invalid email or password.' });

  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).json({ message: 'Invalid email or password.' });

  const token = user.generateauthtoken();
  return res.header('x-auth-token', token).json({
    message: 'User logged in successfully',
    token,
    email: user.email,
    memos: user.memos || [],
  });
});

// ✅ ADD MEMO
function validatememo(req) {
  const schema = joi.object({
    content: joi.string().required(),
  });
  return schema.validate(req);
}

app.post('/addmemo', auth, async (req, res) => {
  const { error } = validatememo(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });

  const user = await User.findById(req.user._id);
  if (!user) return res.status(404).json({ message: 'User not found.' });

  user.memos.push({
    content: req.body.content,
    timestamp: Date.now(),
  });

  await user.save();
  return res.json({ message: 'Memo added successfully', memos: user.memos });
});

// ✅ DELETE MEMO
function validateDelete(req) {
  const schema = joi.object({
    index: joi.number().integer().required(),
  });
  return schema.validate(req);
}

app.post('/deletememo', auth, async (req, res) => {
  const { error } = validateDelete(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });

  const user = await User.findById(req.user._id);
  if (!user) return res.status(404).json({ message: 'User not found' });

  user.memos.splice(req.body.index, 1);
  await user.save();

  return res.json({ message: 'Memo deleted successfully', memos: user.memos });
});

// ✅ SIGNOUT (clears memos after password check)
function validateUpdate(req) {
  const schema = joi.object({
    password: joi.string().min(8).max(16).required(),
  });
  return schema.validate(req);
}

app.post('/signout', auth, async (req, res) => {
  const { error } = validateUpdate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });

  const user = await User.findById(req.user._id);
  if (!user) return res.status(404).json({ message: 'User not found.' });

  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).json({ message: 'Invalid password.' });

  user.memos = [];
  await user.save();

  return res.json({ message: 'Signed out successfully' });
});

module.exports = app;
