select * from review_austin_df
select * from review_dallas_df
select * from listing_austin_df
select * from listing_dallas_df
select * from host_austin_df
select * from host_dallas_df
select * from df_dallas_availability

SELECT *
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
JOIN review_dallas_df r ON l.id = r.listing_id
JOIN df_dallas_availability a on a.id = l.id



SELECT *
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
JOIN review_austin_df r ON l.id = r.listing_id


 
alter table host_austin_df
alter column host_has_profile_pic int
alter table host_austin_df
alter column host_identity_verified int
alter table listing_austin_df
alter column instant_bookable int

----------
UPDATE  host_austin_df
SET host_is_superhost = 0,host_acceptance_rate = 0,host_has_profile_pic = 0 ,host_response_rate = 0
WHERE host_is_superhost IS NULL OR host_acceptance_rate IS NULL OR host_has_profile_pic IS NULL OR host_response_rate IS NULL
 
UPDATE listing_austin_df
SET instant_bookable = 0
WHERE instant_bookable IS NULL




--AUSTIN CITY
------
--a. Analyze different metrics to draw the distinction between Super Host and Other Hosts:
--To achieve this, you can use the following metrics and explore a few yourself as well.
--Acceptance rate, response rate, instant booking, profile picture, identity verified,
--review scores, average no of bookings per month, etc.


SELECT h.host_is_superhost,
	   AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
       AVG(h.host_response_rate) AS avg_response_rate,
	   SUM(l.instant_bookable)
	   AS number_of_instand_pic,
       SUM(h.host_has_profile_pic) 
	   AS number_of_profile_pic,
	   SUM(h.host_identity_verified) 
	   AS number_identity_verified
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost

 
 --b. Using the above analysis, identify the top 3 crucial metrics one needs to maintain 
 --to become a Super Host and also, find their average values.

 with cte as
(SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate, AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS Total_identity_verified
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost)

select host_is_superhost, avg(avg_acceptance_rate+avg_response_rate+avg_review_score_rating) as avg_crucial_matrics from cte
where host_is_superhost=1
group by host_is_superhost;




 --c. Analyze how the comments of reviewers vary for listings of Super Hosts vs Other Hosts(Extract words
 --from the comments provided by the reviewers)



SELECT h.host_is_superhost, count(r.comments) as number_of_postive_comments
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
JOIN review_austin_df r ON l.id = r.listing_id
where r.comments like '%like%' or r.comments like '%good%' or r.comments like '%love%'  
group by h.host_is_superhost 



 SELECT h.host_is_superhost, count(r.comments) as number_of__comments
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
JOIN review_austin_df r ON l.id = r.listing_id
where r.comments like '%bad%' or r.comments like '%not good%' or r.comments like '%improve%' 
group by   h.host_is_superhost




--d. Analyze do Super Hosts tend to have large property types as compared to Other Hosts

 SELECT h.host_is_superhost, count(property_type) as cnt
FROM host_austin_df h
JOIN listing_austin_df l ON h.host_id = l.host_id
JOIN review_austin_df r ON l.id = r.listing_id
where  property_type like '%entire%' 
group by h.host_is_superhost



--DALLAS CITY
alter table host_dallas_df
alter column host_has_profile_pic int
alter table host_dallas_df
alter column host_identity_verified int
alter table listing_dallas_df
alter column instant_bookable int
------

UPDATE  host_dallas_df
SET host_is_superhost = 0,host_acceptance_rate = 0,host_has_profile_pic = 0 ,host_response_rate = 0
WHERE host_is_superhost IS NULL OR host_acceptance_rate IS NULL OR host_has_profile_pic IS NULL OR host_response_rate IS NULL
 
UPDATE listing_dallas_df
SET instant_bookable = 0
WHERE instant_bookable IS NULL

--a. Analyze different metrics to draw the distinction between Super Host and Other Hosts:
--To achieve this, you can use the following metrics and explore a few yourself as well.
--Acceptance rate, response rate, instant booking, profile picture, identity verified,
--review scores, average no of bookings per month, etc.


SELECT h.host_is_superhost,
	   AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
       AVG(h.host_response_rate) AS avg_response_rate,
	   sum(l.instant_bookable)
	   AS number_of_instand_pic,
       SUM(h.host_has_profile_pic) 
	   AS number_of_profile_pic,
	   SUM(h.host_identity_verified) 
	   AS number_identity_verified
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost

 
 --b. Using the above analysis, identify the top 3 crucial metrics one needs to maintain 
 --to become a Super Host and also, find their average values.

 with cte as
(SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate, AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS Total_identity_verified
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost)

select host_is_superhost, avg(avg_acceptance_rate+avg_response_rate+avg_review_score_rating) as avg_crucial_matrics from cte
where host_is_superhost=1
group by host_is_superhost;




 --c. Analyze how the comments of reviewers vary for listings of Super Hosts vs Other Hosts(Extract words
 --from the comments provided by the reviewers)



SELECT h.host_is_superhost, count(r.comments) as number_of_postive_comments
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
JOIN review_dallas_df r ON l.id = r.listing_id
where r.comments like '%like%' or r.comments like '%good%' or r.comments like '%love%'  
group by h.host_is_superhost 



 SELECT h.host_is_superhost, count(r.comments) as number_of__comments
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
JOIN review_dallas_df r ON l.id = r.listing_id
where r.comments like '%bad%' or r.comments like '%not good%' or r.comments like '%improve%' 
group by   h.host_is_superhost




--d. Analyze do Super Hosts tend to have large property types as compared to Other Hosts

 SELECT h.host_is_superhost, count(property_type) as cnt
FROM host_dallas_df h
JOIN listing_dallas_df l ON h.host_id = l.host_id
JOIN review_dallas_df r ON l.id = r.listing_id
where  property_type like '%entire%' 
group by h.host_is_superhost


