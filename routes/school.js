const express = require("express");
const session = require('express-session');
const { dbConnect } = require("../data/database");
const { loginClient } = require("../data/database");

const router = express.Router();

router.get('/:schoolID', async (req,res) =>{
    const userId =   req.session.userData[0];
    const pwd = req.session.userData[1]
    // console.log(userId,pwd)

    const schoolUser = loginClient(userId,pwd)
    schoolUser.connect()
    const schoolPr = new Promise((resolve,reject) => {
        schoolUser.query('SELECT * from school',(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        // res.render("school.ejs",data=result.rows[0])
        })
    });

    const studentsPr =  new Promise((resolve,reject) => {
        schoolUser.query('SELECT * from student',(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(results)
        // res.render("school.ejs",data=result.rows[0])
        })
    });

    const bmiPr =  new Promise((resolve,reject) => {
        const getBmi = 
            `SELECT student_id , student_name ,(weight * 100 * 100 / (height *  height)) as BMI ,
           CASE
            WHEN (weight * 100 * 100 / (height *  height)) < 18.5 THEN 'underweight'
            WHEN (weight * 100 * 100 / (height *  height)) >= 18.5 AND (weight * 100 * 100 / (height *  height)) <= 24.9 THEN 'healthy-weight'
            WHEN (weight * 100 * 100 / (height *  height)) > 24.9 AND (weight * 100 * 100 / (height *  height)) <= 29.9 THEN 'overweight'
            WHEN (weight * 100 * 100 / (height *  height)) > 29.9 THEN 'obese'
          END category
            FROM Student`
     
        schoolUser.query(getBmi,(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(results)
        // res.render("school.ejs",data=result.rows[0])
        })
    });


    Promise.all([schoolPr,studentsPr,bmiPr])
    .then((results)=>{
        console.log((results[2].rows).length,",", (results[0].rows).length,",", (results[1].rows).length)
        // const Sdata = [results[0].rows, results[1].rows]
        res.render("school.ejs",{school: (results[0].rows)[0], students: (results[1].rows)[0], bmi: (results[2].rows)[0]})
    })
    .catch(error=>{
        console.error(error);
    });
   
});

router.get('/:schoolID/updateDailyStock', (req,res) =>{
    updateStock
});

router.get('/:schoolID/stockLeftData', (req,res) =>{
    
});

router.post('/:schoolID/getReports', async (req,res) =>{

    //keep a local variable with connection and then make make query, instead of creating connection
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1];

    const schoolUser = loginClient(userId,pwd);
    schoolUser.connect();

    const month = req.body.month
    const year = req.body.year
    const expenses = await new Promise((resolve,reject)=>{
        const queryExpense = `select * from school_monthly_expenses_func(${userId},${month},${year})`
        schoolUser.query(queryExpense,(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(results)
        });
    });
    // console.log(expenses.rows)
    // res.redirect(`getReports`)

    res.render("reports.ejs",{data:(expenses.rows)[0], schoolid: userId,m:month, y:year})
});

router.get('/:schoolID/getReports', async (req,res) =>{
    // console.log("hee")
    console.log(req.body)
    // res.render("school.ejs",{results.rows})
});

router.get('/:schoolID/getBMIinfo', (req,res) =>{
    
});

router.get('/:schoolID/StudentTable', (req,res) =>{
    
});

// router.get('/:')
module.exports = router;