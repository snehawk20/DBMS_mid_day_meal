const express = require("express");
const session = require('express-session');
const { dbConnect } = require("../data/database");
const { loginClient } = require("../data/database");

const router = express.Router();

router.get('/:cityID', async (req,res) =>{
    const userId = req.session.userData[0];
    const pwd = req.session.userData[1];

    const cityUser = loginClient(userId,pwd);
    cityUser.connect()

//     cityUser.query('SELECT * from school',(err,result)=>{
//         if(err)
//             throw err
//         else
//     res.render("city.ejs",data=result.rows[0])
// }
//     )

    const schoolPr = new Promise((resolve,reject) => {
        cityUser.query('SELECT school_id, school_name from school;',(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        //res.render("city.ejs",data=result.rows[0])
        })
    });

    const cityPr = new Promise((resolve,reject) => {
        cityUser.query('SELECT * from city_committee;',(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        //res.render("city.ejs",data=result.rows[0])
        })
    });

    const itemPr = new Promise((resolve,reject) => {
        cityUser.query('SELECT item_name, price from item_prices;',(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        //res.render("city.ejs",data=result.rows[0])
        })
    });

    const districtID = await new Promise((resolve,reject) => {
        cityUser.query(`SELECT district_id from city_committee;`,(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        //res.render("city.ejs",data=result.rows[0])
        })
    });

    const id = districtID.rows[0].district_id ;
    // console.log(id);
    // console.log(districtID.rows[0].district_id)
    const grievancesPr = new Promise((resolve,reject) => {
        cityUser.query(`SELECT complaint_number, school_id, complaint_details from district_grievances_data_func(${id});`,(err,result)=>{
            if(err)
                reject(err)
            else
                resolve(result)
        //res.render("city.ejs",data=result.rows[0])
        })
    });

    Promise.all([schoolPr,itemPr,grievancesPr, cityPr])
    .then((results)=>{
        console.log((results[2].rows).length,",", (results[0].rows).length,",", (results[1].rows).length,",", (results[3].rows))
        // const Sdata = [results[0].rows, results[1].rows]
        res.render("city.ejs",{schools: (results[0].rows), items: (results[1].rows), grieve: (results[2].rows), city_committee: (results[3].rows)[0]})
    })
    .catch(error=>{
        console.error(error);
    });
});


module.exports = router;