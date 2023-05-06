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

    const stockPr =  new Promise((resolve,reject) => {
        const getStock = 
            `
             select * from stock_left where month = (extract (month from current_date)) and year = (extract (year from current_date));
            `     
        schoolUser.query(getStock,(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(results)
        // res.render("school.ejs",data=result.rows[0])
        })
    });


    Promise.all([schoolPr,studentsPr,bmiPr,stockPr])
    .then((results)=>{
        // console.log(results[3].rows)
        // console.log((results[2].rows),",", (results[0].rows),",", (results[1].rows),",", (results[3].rows))
        // const Sdata = [results[0].rows, results[1].rows]
        res.render("school.ejs",{school: (results[0].rows)[0], students: (results[1].rows), bmi: (results[2].rows), stock: (results[3].rows)})
    })
    .catch(error=>{
        console.error(error);
    });
   
});


router.post('/:schoolID/addStock', async (req,res) =>{
        //keep a local variable with connection and then make make query, instead of creating connection
        const userId = req.session.userData[0];
        const pwd = req.session.userData[1];
    
        const schoolUser = loginClient(userId,pwd);
        schoolUser.connect();

        // console.log(req.body)
        const {item1,item2,item3,item4,item5,item6,item7} = req.body
    
        const stockLs = await new Promise((resolve,reject)=>{
            const querystock = `update stock_left 
            set item_quantity = case
             when item_name = 'item1' then item_quantity + ${item1}
             when item_name = 'item2' then item_quantity + ${item2}
             when item_name = 'item3' then item_quantity + ${item3}
             when item_name = 'item4' then item_quantity + ${item4}
             when item_name = 'item5' then item_quantity + ${item5}
             when item_name = 'item6' then item_quantity + ${item6}
             when item_name = 'item7' then item_quantity + ${item7}
             end
             where item_name in ('item1','item2','item3','item4','item5','item6','item7') and 
             month = (extract (month from current_date)) and year = (extract (year from current_date))

            `
            schoolUser.query(querystock,(err,results)=>{
                if(err)
                    reject(err)
                else
                    resolve(results)
            });
        });
        res.redirect("addStock")
});

router.get('/:schoolID/addStock', (req,res)=>{
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1]; 

    const schoolUser = loginClient(userId,pwd);
    schoolUser.connect();

   
    const querystock = `  
        select * from stock_left where month = (extract(month from current_date)) and year = (extract(year from current_date));
        `
    schoolUser.query(querystock,(err,results)=>{
            if(err)
                throw (err)
            else{
                // console.log(results.rows)
                res.render("addStock.ejs",{schoolid: userId, stockData:results.rows})
            } 
     });
    
})


router.post('/:schoolID/updateUsage', async (req,res) =>{
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1];

    const schoolUser = loginClient(userId,pwd);
    schoolUser.connect();

    const {item1,item2,item3,item4,item5,item6,item7} = req.body
    // console.log(req.body)

    const usageLs = await new Promise((resolve,reject)=>{
          const queryUsage = `
            insert into daily_stock_usage (school_id,item_name,date,item_quantity)
            values 
            (${userId},'item1', (select now()::date),cast(${item1} as integer)),
            (${userId},'item2', (select now()::date),cast(${item2} as integer)),
            (${userId},'item3', (select now()::date),cast(${item3} as integer)),
            (${userId},'item4', (select now()::date),cast(${item4} as integer)),
            (${userId},'item5', (select now()::date),cast(${item5} as integer)),
            (${userId},'item6', (select now()::date),cast(${item6} as integer)),
            (${userId},'item7', (select now()::date),cast(${item7} as integer))
            
            on conflict on constraint daily_stock_usage_pkey
            do
                update set item_quantity = case
                when (daily_stock_usage.item_name = 'item1' )then ${item1}
                when (daily_stock_usage.item_name = 'item2' )then ${item2}
                when (daily_stock_usage.item_name = 'item3' )then ${item3}
                when (daily_stock_usage.item_name = 'item4' )then ${item4}
                when (daily_stock_usage.item_name = 'item5' )then ${item5}
                when (daily_stock_usage.item_name = 'item6' )then ${item6}
                when (daily_stock_usage.item_name = 'item7' )then ${item7}
                end
                where daily_stock_usage.item_name in ('item1','item2','item3','item4','item5','item6','item7') and 
                daily_stock_usage.date = (select now()::date) and daily_stock_usage.school_id = ${userId}  
                
        `
        schoolUser.query(queryUsage,(err,results)=>{
            if(err)
                reject(err)
            else
                resolve(err)
        });
    });

    res.redirect("updateUsage");

});

router.get('/:schoolID/updateUsage', (req,res) =>{
   
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1]; 

    const schoolUser = loginClient(userId,pwd);
    schoolUser.connect();

   
    const queryUsage = `  
        select * from daily_stock_usage where extract (month from date) = extract(month from current_date);
        `
    schoolUser.query(queryUsage,(err,results)=>{
            if(err)
                throw (err)
            else{
                // console.log(results.rows)
                res.render("updateUsage.ejs",{schoolid: userId, usageData:results.rows})
            } 
     });
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
    // console.log(req.body)
    // res.render("school.ejs",{results.rows})
});

router.get('/:schoolID/StudentTable', (req,res) =>{
    
});

// router.get('/:')
module.exports = router;