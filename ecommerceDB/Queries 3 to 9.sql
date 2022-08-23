#Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
select count(t2.cus_gender) as NoOfCustomers, t2.cus_gender from
(select t1.cus_id, t1.cus_gender, t1.ord_amount, t1.cus_name from
(select `order_table`.*, customer.cus_gender, customer.cus_name from `order_table` inner join customer where `order_table`.cus_id=customer.cus_id having
`order_table`.ord_amount>=3000)
as t1 group by t1.cus_id) as t2 group by t2.cus_gender;
#Display all the orders along with product name ordered by a customer having Customer_Id=2
select product.pro_name, `order_table`.* from `order_table`, supplier_pricing, product
where `order_table`.cus_id=2 and
`order_table`.pricing_id=supplier_pricing.pricing_id and supplier_pricing.pro_id=product.pro_id;
#Display the Supplier details who can supply more than one product.
select supplier.* from supplier where supplier.supp_id in 
 (select supp_id  from supplier_pricing group by supp_id having
count(supp_id)>1)group by supplier.supp_id;
#Find the least expensive product from each category and print the table with category id, name, product name and price of the product
select category.*, min(t3.min_price) as Min_Price,t3.pro_name from category inner join
(select product.cat_id, product.pro_name, t2.* from product inner join
(select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id)
as t2 where t2.pro_id = product.pro_id)
as t3 where t3.cat_id = category.cat_id group by t3.cat_id;
#Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT product.PRO_ID, product.PRO_NAME FROM product INNER JOIN
(SELECT SP.PRICING_ID, SP.PRO_ID FROM supplier_pricing AS SP INNER JOIN 
(SELECT PRICING_ID, ORD_DATE FROM `order_table` where ORD_DATE>"2021-10-05") AS T1 ON T1.PRICING_ID=SP.PRICING_ID) 
AS T2 ON product.PRO_ID=T2.PRO_ID ;
#Display customer name and gender whose names start or end with character 'A'.
select customer.cus_name,customer.cus_gender from customer where customer.cus_name like 'A%' or 
customer.cus_name like '%A';
#9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc`()
BEGIN
select report.supp_id,report.supp_name,report.Average,
CASE
WHEN report.Average =5 THEN 'Excellent Service'
WHEN report.Average >4 THEN 'Good Service'
WHEN report.Average >2 THEN 'Average Service'
ELSE 'Poor Service'
END AS Type_of_Service from
(select final.supp_id, supplier.supp_name, final.Average from
(select test2.supp_id, sum(test2.rat_ratstars)/count(test2.rat_ratstars) as Average from
(select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from supplier_pricing inner join
(select `order_table`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from `order_table` inner join rating on rating.`ord_id` = `order_table`.ord_id ) as test
on test.pricing_id = supplier_pricing.pricing_id)
as test2 group by supplier_pricing.supp_id)
as final inner join supplier where final.supp_id = supplier.supp_id) as report;
END
%%DELIMITER ;
 CALL proc();

