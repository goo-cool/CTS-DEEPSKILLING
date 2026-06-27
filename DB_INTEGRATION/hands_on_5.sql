// =========================================
// HANDS-ON 5
// MongoDB - Document Modelling, CRUD & Aggregation
// =========================================


// =========================================
// TASK 1 : CREATE COLLECTION & INSERT DOCUMENTS
// Q60 - Q64
// =========================================

use college_nosql

db.createCollection("feedback")


db.feedback.insertMany([
{student_id:1,course_code:"CS101",semester:"2022-ODD",rating:5,comments:"Excellent teaching, would recommend.",tags:["challenging","well-structured","good-examples"],submitted_at:new Date("2022-11-30"),attachments:[{filename:"notes.pdf",size_kb:240}]},
{student_id:2,course_code:"CS101",semester:"2022-ODD",rating:4,comments:"Very useful course.",tags:["well-structured","practical"],submitted_at:new Date("2022-11-29"),attachments:[{filename:"assignment.pdf",size_kb:180}]},
{student_id:5,course_code:"CS101",semester:"2022-ODD",rating:5,comments:"Highly recommended.",tags:["challenging","good-examples"],submitted_at:new Date("2022-11-28"),attachments:[{filename:"lab.pdf",size_kb:120}]},
{student_id:1,course_code:"CS102",semester:"2022-ODD",rating:4,comments:"Database concepts are clear.",tags:["database","sql"],submitted_at:new Date("2022-12-01"),attachments:[{filename:"db_notes.pdf",size_kb:150}]},
{student_id:5,course_code:"CS102",semester:"2022-ODD",rating:3,comments:"Moderate difficulty.",tags:["database","average"],submitted_at:new Date("2022-12-02"),attachments:[{filename:"queries.pdf",size_kb:110}]},
{student_id:2,course_code:"CS103",semester:"2022-ODD",rating:5,comments:"Loved OOP concepts.",tags:["oop","java"],submitted_at:new Date("2022-11-25"),attachments:[{filename:"oop.pdf",size_kb:210}]},
{student_id:3,course_code:"EC101",semester:"2021-EVEN",rating:2,comments:"Needs better examples.",tags:["electronics","difficult"],submitted_at:new Date("2021-12-01"),attachments:[{filename:"circuits.pdf",size_kb:300}]},
{student_id:6,course_code:"EC101",semester:"2021-EVEN",rating:1,comments:"Hard to follow lectures.",tags:["electronics","challenging"],submitted_at:new Date("2021-12-05"),attachments:[{filename:"review.pdf",size_kb:90}]},
{student_id:4,course_code:"ME101",semester:"2023-ODD",rating:4,comments:"Good explanations.",tags:["mechanical","practical"],submitted_at:new Date("2023-11-10"),attachments:[{filename:"thermo.pdf",size_kb:250}]},
{student_id:7,course_code:"ME101",semester:"2023-ODD",rating:5,comments:"Very engaging course.",tags:["mechanical","well-structured"],submitted_at:new Date("2023-11-15")}
])

db.feedback.countDocuments()


// =========================================
// TASK 2 : CRUD OPERATIONS
// Q65 - Q70
// =========================================

// Q65
db.feedback.find({rating:5})

// Q66
db.feedback.find({course_code:"CS101",tags:"challenging"})

// Q67
db.feedback.find({},{student_id:1,course_code:1,rating:1,_id:0})

// Q68
db.feedback.updateMany({rating:{$lt:3}},{$set:{needs_review:true}})

// Verify
db.feedback.find({needs_review:true})

// Q69
db.feedback.updateMany({needs_review:true},{$push:{tags:"reviewed"}})

// Verify
db.feedback.find({needs_review:true})

// Q70
db.feedback.deleteMany({semester:"2021-EVEN"})

// Verify
db.feedback.find({semester:"2021-EVEN"})


// =========================================
// TASK 3 : AGGREGATION PIPELINE
// Q71 - Q74
// =========================================

// Q71
db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{$group:{_id:"$course_code",average_rating:{$avg:"$rating"},total_feedback:{$sum:1}}},
{$sort:{average_rating:-1}}
])


// Q72
db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{$group:{_id:"$course_code",average_rating:{$avg:"$rating"},total_feedback:{$sum:1}}},
{$project:{course_code:"$_id",average_rating:{$round:["$average_rating",1]},total_feedback:1,_id:0}},
{$sort:{average_rating:-1}}
])


// Q73
db.feedback.aggregate([
{$unwind:"$tags"},
{$group:{_id:"$tags",count:{$sum:1}}},
{$sort:{count:-1}}
])


// Q74
db.feedback.createIndex({course_code:1})

db.feedback.find({course_code:"CS101"}).explain("executionStats")


