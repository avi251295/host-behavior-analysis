--CHINA


--a. Analyze different metrics to draw the distinction between Super Host and Other Hosts:
--To achieve this, you can use the following metrics and explore a few yourself as well.
--Acceptance rate, response rate, instant booking, profile picture, identity verified, review scores, average no of bookings per month, etc.

----Beijing

select top 10 * from host_beijing_df
select top 10 * from review_beijing_df
select top 10 * from listing_beijing_df

update host_beijing_df
set host_response_rate=0 ,host_acceptance_rate=0, host_is_superhost=0,host_has_profile_pic='TRUE', host_identity_verified='True'
where host_response_rate is null or host_acceptance_rate is null or host_is_superhost is null or host_has_profile_pic is null 
or host_identity_verified is null ;

update host_beijing_df
set host_has_profile_pic=1
where host_has_profile_pic='TRUE'

update host_beijing_df
set host_has_profile_pic=0
where host_has_profile_pic='FALSE'

update host_beijing_df
set host_identity_verified=1
where host_identity_verified='TRUE'

update host_beijing_df
set host_identity_verified=0
where host_identity_verified='FALSE'



alter table host_beijing_df
alter column host_has_profile_pic int
alter table host_beijing_df
alter column host_identity_verified int
alter table listing_beijing_df
alter column instant_bookable int

SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate, AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS Total_identity_verified,
count(h.host_id) as "Number_of_Hosts", sum(host_listings_count) as Total_listings,
avg(accommodates) as Avg_Accomodates, max(bedrooms) as Max_Bedrooms,
min(price) as Min_Price
FROM host_beijing_df h
JOIN listing_beijing_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost;

--Shanghai

select top 10 * from host_shanghai_df
select top 10 * from review_shanghai_df
select top 10 * from listing_shanghai_df

update host_shanghai_df
set host_response_rate=0 ,host_acceptance_rate=0, host_is_superhost=0,host_has_profile_pic='TRUE'
where host_response_rate is null or host_acceptance_rate is null or host_is_superhost is null or host_has_profile_pic is null  ;

update host_shanghai_df
set host_has_profile_pic=1
where host_has_profile_pic='TRUE'

update host_shanghai_df
set host_has_profile_pic=0
where host_has_profile_pic='FALSE'

alter table host_shanghai_df
alter column host_has_profile_pic int
alter table host_shanghai_df
alter column host_identity_verified int
alter table listing_shanghai_df
alter column instant_bookable int

SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate,AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS number_identity_verified,
count(h.host_id) as "Number_of_Hosts", sum(host_listings_count) as Total_listings,
avg(accommodates) as Avg_Accomodates, max(bedrooms) as Max_Bedrooms,
min(price) as Min_Price
FROM host_shanghai_df h
JOIN listing_shanghai_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost;

--b.Using the above analysis, identify the top 3 crucial metrics one needs to maintain to become a Super Host and also, find their average values.

--Beijing

---top 3 matrics to maintain a become superhost are:-

--1.Acceptance rate: It is important to have a high acceptance rate to show that you are reliable and responsive to booking requests.

--2.Response rate: A high response rate demonstrates that you are available and easy to communicate with, which can help build trust with potential guests.

--3.Review scores: High review scores show that you are offering a high-quality experience and are likely to attract more bookings.

with cte as
(SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate, AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS Total_identity_verified,
count(h.host_id) as "Number_of_Hosts", sum(host_listings_count) as Total_listings,
avg(accommodates) as Avg_Accomodates, max(bedrooms) as Max_Bedrooms,
min(price) as Min_Price
FROM host_beijing_df h
JOIN listing_beijing_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost)

select host_is_superhost,avg_acceptance_rate,avg_review_score_rating,avg_response_rate ,
avg(avg_acceptance_rate+avg_response_rate+avg_review_score_rating) as avg_crucial_matrics from cte
where host_is_superhost is not null
group by host_is_superhost,avg_acceptance_rate,avg_review_score_rating,avg_response_rate;

----Shanghai

with cte as
(SELECT h.host_is_superhost,AVG(h.host_acceptance_rate) AS avg_acceptance_rate,
AVG(h.host_response_rate) AS avg_response_rate,AVG(l.review_scores_rating) as avg_review_score_rating,
SUM(l.instant_bookable) AS total_instand_bookable,
SUM(h.host_has_profile_pic) AS total_profile_pic, 
SUM(h.host_identity_verified) AS number_identity_verified,
count(h.host_id) as "Number_of_Hosts", sum(host_listings_count) as Total_listings,
avg(accommodates) as Avg_Accomodates, max(bedrooms) as Max_Bedrooms,
min(price) as Min_Price
FROM host_shanghai_df h
JOIN listing_shanghai_df l ON h.host_id = l.host_id
GROUP BY host_is_superhost)

select host_is_superhost,avg_acceptance_rate,avg_review_score_rating,avg_response_rate ,
avg(avg_acceptance_rate+avg_response_rate+avg_review_score_rating) as avg_crucial_matrics from cte
where host_is_superhost is not null
group by host_is_superhost,avg_acceptance_rate,avg_review_score_rating,avg_response_rate;

--c.Analyze how the comments of reviewers vary for listings of Super Hosts vs Other Hosts(Extract words from the comments provided by the reviewers)

---Beijing

SELECT h.host_is_superhost, count(r.comments) as number_of_postive_comments
FROM host_beijing_df h
JOIN listing_beijing_df l ON h.host_id = l.host_id
JOIN review_beijing_df r ON l.id = r.listing_id
where r.comments like '%like%' or r.comments like '%good%' or r.comments like '%love%'  
group by h.host_is_superhost 



SELECT h.host_is_superhost, count(r.comments) as number_of_negative_comments
FROM host_beijing_df h
JOIN listing_beijing_df l ON h.host_id = l.host_id
JOIN review_beijing_df r ON l.id = r.listing_id
where r.comments like '%bad%' or r.comments like '%not good%' or r.comments like '%improve%' 
group by   h.host_is_superhost

--Shanghai

SELECT h.host_is_superhost, count(r.comments) as number_of_postive_comments
FROM host_shanghai_df h
JOIN listing_shanghai_df l ON h.host_id = l.host_id
JOIN review_shanghai_df r ON l.id = r.listing_id
where r.comments like '%like%' or r.comments like '%good%' or r.comments like '%love%'  
group by h.host_is_superhost 



SELECT h.host_is_superhost, count(r.comments) as number_of_negative_comments
FROM host_shanghai_df h
JOIN listing_shanghai_df l ON h.host_id = l.host_id
JOIN review_shanghai_df r ON l.id = r.listing_id
where r.comments like '%bad%' or r.comments like '%not good%' or r.comments like '%improve%' 
group by  h.host_is_superhost


--d.Analyze do Super Hosts tend to have large property types as compared to Other Hosts

--Beijing

SELECT h.host_is_superhost, count(property_type) as number_large_property
FROM host_beijing_df h
JOIN listing_beijing_df l ON h.host_id = l.host_id
JOIN review_beijing_df r ON l.id = r.listing_id
where  property_type like '%entire%'
group by h.host_is_superhost

--Shanghai

SELECT h.host_is_superhost, count(property_type) as number_large_property
FROM host_shanghai_df h
JOIN listing_shanghai_df l ON h.host_id = l.host_id
JOIN review_shanghai_df r ON l.id = r.listing_id
where  property_type like '%entire%'
group by h.host_is_superhost