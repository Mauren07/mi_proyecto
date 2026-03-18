/**
*Author:   DIEGO CASALLAS
*Date:     01/01/2026
*Description: Controller for user status catalog operations.
**/
import UserStatusModel from '../models/userStatus.model.js';

export const showUserStatus = async (req, res) => {
  try {
    const userStatusModel = new UserStatusModel();
    await userStatusModel.showUserStatus(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error fetching user statuses",
      details: error.message,
    });
  }
};

export const showUserStatusId = async (req, res) => {
  try {
    const userStatusModel = new UserStatusModel();
    await userStatusModel.showUserStatusId(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error fetching user status",
      details: error.message,
    });
  }
};

export const addUserStatus = async (req, res) => {
  try {
    const userStatusModel = new UserStatusModel();
    await userStatusModel.addUserStatus(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error adding user status",
      details: error.message,
    });
  }
};

export const updateUserStatus = async (req, res) => {
  try {
    const userStatusModel = new UserStatusModel();
    await userStatusModel.updateUserStatus(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error updating user status",
      details: error.message,
    });
  }
};

export const deleteUserStatus = async (req, res) => {
  try {
    const userStatusModel = new UserStatusModel();
    await userStatusModel.deleteUserStatus(req, res);
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: "Error deleting user status",
      details: error.message,
    });
  }
};
