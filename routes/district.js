const express = require("express");
const { dbConnect } = require("../data/database");
const session = require('express-session');
const { loginClient } = require("../data/database");
const router = express.Router();


router.get('/:districtID', (req,res) =>{
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1]
    const schoolUser = loginClient(userId,pwd)

    schoolUser.connect()
    schoolUser.query('SELECT * from school',(err,result)=>{
        if(err)
            throw err
        else
    res.render("district.ejs",data=result.rows[0])
}
    )
});

module.exports = router;