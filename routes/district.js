const express = require("express");
const { dbConnect } = require("../data/database");
const session = require('express-session');
const { loginClient } = require("../data/database");
const router = express.Router();


router.get('/:districtID', async (req,res) =>{
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1]
    const districtUser = loginClient(userId,pwd)
    districtUser.connect()
    console.log(userId)

    const districtID = Number(userId.replace(/^district_officer/ , ''))

    const districtPr = new Promise((resolve , reject) => {
        districtUser.query('SELECT * from district_committee',(err,result)=>{
            if(err)
            {
                console.log("trouble")
                reject(err)
            }
            else
                resolve(result) 
        // res.render("district.ejs",data=result.rows[0])
        })
    });

    const extraBudgetPr = new Promise((resolve , reject) => {
        const budgetquery = `SELECT * FROM calc_extra_budget(${districtID})`
        districtUser.query(budgetquery , (err , result) => {
            if(err)
                reject(err)
            else
                resolve(result)             
        })
    });

    const grievancesPr = new Promise((resolve , reject) => {
        const grievancesquery = `SELECT * FROM district_grievances_data_func(${districtID})`
        districtUser.query(grievancesquery , (err , result) => {
            if(err)
                reject(err)
            else
                resolve(result)             
        })
    });

    const menuPr = new Promise((resolve , reject) => {
        districtUser.query('SELECT * FROM district_static' , (err , result) => {
            if(err)
                reject(err)
            else 
                resolve(result)
        })
    });

    const cityPr = new Promise((resolve , reject) => {
        districtUser.query('SELECT * FROM city_committee' , (err , result) => {
            if(err)
                reject(err)
            else
            {
                resolve(result)
            }
        })
    });


       
    Promise.all([districtPr , menuPr , extraBudgetPr , cityPr , grievancesPr])
    .then((results)=>{
        // console.log((results[3].rows).length)
        res.render("district.ejs",{districtPr : (results[0].rows)[0], menuPr : results[1].rows, extraBudgetPr: (results[2].rows)  , cityPr: (results[3].rows), grievancesPr: (results[4].rows)})
    })
    .catch(error=>{
        console.error(error);
    });
});


router.post('/:districtID/monthlySchoolReport' , async(req , res) => {
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1];
    const districtID = Number(userId.replace(/^district_officer/ , ''))

    const schoolUser = loginClient(userId,pwd);
    schoolUser.connect();

    const month = req.body.month
    const year = req.body.year    
    const report_detailsPr = await new Promise((resolve,reject)=>{
        const reportquery = `select * from get_schools_data(${districtID},${month},${year})`
        schoolUser.query(reportquery,(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(results)
        });
    });
    res.render("monthlySchoolReport.ejs" , {monthPr : month, yearPr: year, report_details : report_detailsPr.rows , district_id : districtID})
});

router.get('/:districtID/monthlySchoolReport' , (req,res) => {
    console.log("Published Report")
})


module.exports = router;
