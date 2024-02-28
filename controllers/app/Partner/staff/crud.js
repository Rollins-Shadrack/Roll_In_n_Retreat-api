const asyncHandler = require('express-async-handler')

/**
 * @Description Create a new staff
 * @Method POST
 * @Params [partnerId]
 * @Request
 * @Response success
 */

/**
 * @Description Get all staff members
 * @Method GET
 * @Params [partnerId]
 * @Request
 * @Response All staff members
 */
const getAllStaffMembers = asyncHandler(async (req, res, next) => {
    // console.log("crud current user",req.user)
})

/**
 * @Description Get a specific staff member
 * @Method GET
 * @Params [partnerId@string, staffId]
 * @Request
 * @Response single staff member
 */

/**
 * @Description Update a specific staff
 * @Method PATCH/UPDATE
 * @Params [partnerId@string, staffId@string]
 * @Request
 * @Response success
 */

/**
 * @Description delete a specific staff
 * @Method Delete
 * @Params [partnerId@string, staffId@string]
 * @Request
 * @Response success
 */

module.exports = {
    getAllStaffMembers
}