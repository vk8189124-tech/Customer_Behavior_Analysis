use customer_behavior;

-- Q1:- what is the total revenue genterated by male vs female customers
select gender,sum(purchase_amount) as revenue 
from customer_behavior 
group by gender;

-- Q2:- which customer used discount but still spend more than the average purchase amount
 select customer_id,purchase_amount
 from customer_behavior
 where discount_applied = "yes" and purchase_amount >= (select avg(purchase_amount) from customer_behavior); 
 
 -- Q3:- which are the top 5 product with the highest average review rating
 select item_purchased,round(avg(review_rating),2) as average_product_rating
 from customer_behavior
 group by item_purchased
 order by avg(review_rating) desc limit 5;
 
 -- Q4. compare the average purchase amount between standard and express shipping
 select shipping_type ,round(avg(purchase_amount),2)
 from customer_behavior
 where shipping_type in ("standard","express")
 group by shipping_type;
 
 -- Q5. Do sucscribe customer spend more? comprare average spend and total revenue between subscribes and non subscribes
 select subscription_status,count(customer_id) as total_customers,
 round(avg(purchase_amount),2) as avg_spend,
 round(sum(purchase_amount),2) as total_revenue
 from customer_behavior
 group by subscription_status
 order by total_revenue,avg_spend desc;
 
 -- Q6. which 5 products have the highest percentage of purchases with discounts applied.
 select item_purchased,
 round(100 * sum(case when discount_applied = "yes" then 1 else 0 end)/count(*),2) as discount_rate
 from customer_behavior
 group by item_purchased
 order by discount_rate desc
 limit 5;
 
 -- Q7. segment customers into new returing and loyal based on their total number of previous purchases and show the cost of each segement.
 with customer_type as (
 select customer_id ,previous_purchases,
 case 
	  when previous_purchases = 1 then "new"
      when previous_purchases between 2 and 10 then "returning"
      else "loyal"
      end as customer_segment
      from customer_behavior
    )
    select customer_segment,count(*) as "number of customer"
    from customer_type
    group by customer_segment;
 
 -- Q8. what are the top 3 most purchased product within each category.
 with item_counts as (
 select category,
 item_purchased,
 count(customer_id) as total_orders,
 row_number()over(partition by category order by count(customer_id)desc)as item_rank
 from customer_behavior
 group by category,item_purchased
 )
 select item_rank ,category,item_purchased,total_orders
 from item_counts
 where item_rank <= 3;
 
 -- Q9. are customer who are repeat buyers (more than 5 previous purchasse) also likelyl to subscribe.
 select subscription_status,
 count(customer_id) as repeat_buyers
 from customer_behavior
 where previous_purchases > 5
 group by subscription_status
 
 -- q10. what is the revanue constribution of each age group.
 select age_group,
 sum(purchase_amount) as total_revenue
 from customer_behavior
 group by age_group
 order by total_revenue desc;
 
 show databases;