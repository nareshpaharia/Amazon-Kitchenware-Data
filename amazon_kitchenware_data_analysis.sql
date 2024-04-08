CREATE DATABASE amazon_kitchenware;

/* Q1:What are the top 5 brands with the highest average star 
      ratings among products with prices above the overall average price?*/
 
 SELECT * FROM kitchen;

SELECT brand,AVG(stars) AS star 
FROM kitchen
WHERE price_value>(SELECT AVG(price_value) 
                   FROM kitchen)
GROUP BY brand
ORDER BY star DESC
LIMIT 5;

/*Q2:What are the top 5 products with the highest number of reviews?*/

SELECT brand,reviewsCount AS reviews
FROM kitchen
GROUP BY brand,reviews 
ORDER BY reviews DESC
LIMIT 5; 

/*Q3:Which products have prices lower than the average price of 
     products within their respective breadcrumb category?*/
 
 SELECT title,price_value,breadCrumbs
 FROM kitchen AS a
 WHERE price_value<(SELECT AVG(price_value) AS avg_price
                    FROM kitchen AS b WHERE a.breadCrumbs=b.breadCrumbs);
                    
/*Q4:What is the average number of reviews for products 
     priced higher than the average price of products with 
     a star rating greater than 4?*/
  
SELECT AVG(reviewsCount) AS avg_review
FROM kitchen
WHERE price_value>(SELECT AVG(price_value) AS avg_price
                   FROM kitchen WHERE stars>4) ;
                   
/*Q5:Which products have a star rating greater than the average star 
     rating of products within their respective brand?*/

 SELECT title,stars,brand 
 FROM kitchen a
 WHERE stars>(SELECT AVG(stars) AS avg_star 
              FROM kitchen b 
              WHERE a.brand=b.brand); 
              
/*Q6:What is the average price difference between products 
     with a star rating greater than 4 and those with a star
     rating less than or equal to 4?*/              
              
 SELECT AVG(price_value) AS avg_price
 FROM kitchen
 WHERE stars>4 AND stars<=4;
 
/*Q7:Create a new column indicating whether a 
  product has a star rating above 4 or not*/

SELECT *,
CASE WHEN stars>4 THEN 'HIGH'
ELSE 'LOW' end AS rating_category
FROM kitchen;
 
/*Q8:Classify products into three price categories: 
     low, medium, and high, based on their price values.*/ 

SELECT title, price_value,
CASE WHEN price_value<50 THEN 'LOW'
     WHEN price_value>=50 AND price_value<= 100 THEN 'MEDIUM'
     ELSE 'LOW'
     END AS price_categories
FROM  kitchen;

/*Q9:Calculate the total sales revenue for each brand,
     considering only products with a star rating above 4 */
SELECT * FROM kitchen;

WITH HighRatingProducts AS (
                           SELECT *
                           FROM kitchen
                           WHERE stars > 4)
SELECT brand, SUM(price_value) AS total_revenue
FROM HighRatingProducts
GROUP BY brand;
  
/*Q10:Identify the top 5 products with the highest 
     number of reviews, along with their respective brands.*/ 

WITH TopProducts AS
                  (SELECT *,
				  ROW_NUMBER() OVER(ORDER BY reviewsCount desc) as rnk
                  FROM kitchen)
SELECT title,brand,reviewsCount
FROM TopProducts
WHERE rnk<=5;

/*Q11:Calculate the average price for each breadcrumb category, 
      only considering products with a star rating above 4.*/

WITH HighRatingProducts AS 
                         (SELECT * FROM
						  kitchen
                          WHERE stars>4)
SELECT breadCrumbs,round(AVG(price_value),0) AS avg_price
FROM HighRatingProducts 
GROUP BY breadCrumbs;

/*Q12:Identify the top 3 brands with the 
      highest total sales revenue.*/
SELECT * FROM kitchen;
      
WITH BrandRevenue  AS 
           (SELECT brand, round(SUM(price_value),0) AS total_sales_revnue
            FROM kitchen
            GROUP BY brand)

SELECT brand,total_sales_revnue
FROM BrandRevenue 
GROUP BY brand
ORDER BY total_sales_revnue DESC
LIMIT 3;

/*Q13:Calculate the average number of reviews for 
      products priced above the overall average price*/
 
SELECT brand,AVG(reviewsCount) AS review
FROM kitchen
WHERE price_value>(SELECT AVG(price_value) AS avg_price FROM kitchen)
GROUP BY brand; 

WITH AvgPrice AS (
    SELECT AVG(price_value) AS avg_price
    FROM kitchen
)
SELECT AVG(reviewsCount) AS avg_reviews
FROM kitchen
WHERE price_value > (SELECT avg_price FROM AvgPrice);

-- --------------------------------------------------------
/*Q14:Identify products with prices higher than the average 
      price of products within their respective breadcrumb category, 
      and among those products, find the ones with the highest number of reviews.*/

SELECT title, price_value, reviewsCount
FROM kitchen A
WHERE price_value > (
    SELECT AVG(price_value)
    FROM kitchen B
    WHERE A.breadCrumbs = B.breadCrumbs
)
ORDER BY reviewsCount DESC
LIMIT 5;


/*Q15:Identify brands where the average star rating of their products is 
      higher than the average star rating across all brands, and for each 
      such brand, list the products with prices above the brand's average price*/
      
WITH BrandAvgRating AS    
                   (SELECT brand,AVG(stars) as avg_star 
                    FROM kitchen
                    GROUP BY brand) ,
BrandAvgPrice AS
                (SELECT brand,AVG(price_value)as avg_price
                FROM kitchen
                GROUP BY brand)  
 
 SELECT A.brand,A.title,A.price_value
 FROM kitchen A
 JOIN BrandAvgRating B ON A.brand=B.brand
 JOIN BrandAvgPrice C ON C.brand=A.brand
 WHERE B.avg_star>
                 (SELECT AVG(stars) 
                  FROM kitchen)
 AND A.price_value>C.avg_price;

-- -----------------------------------------END---------------------------------------------------------
-- -----------------------------------------END---------------------------------------------------------
   