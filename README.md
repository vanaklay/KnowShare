# KNOWSHARE

### Welcome to KnowShare!


![](https://abaforlawstudents.com/wp-content/uploads/2020/03/online-study-tips.jpg)

## What is KnowShare?

Have you ever gone to study at a friend's house and realized that his explanations were sometimes clearer than the ones of your teacher?

Wouldn't it be nice to have an online platform that would put you in contact with people willing to share their knowledge and experience with you? 

KnowShare connects people that have one thing in common: the thirst for learning. 
It allows people to share their knowledge with one another: they can offer a course, and in return take a course from someone else. 

## Objectives of this project

This is a final projects required to validate the first 3 months of a 6 months-long coding bootcamp. It was all coded in pair programming by 4 students: @Rudyar @vanaklay @Mtwod @colinebrlt

The main objectives of this project were to:
* learn the importance of the agile methodology and comprehend its importance when it comes to teamwork
* realize that after just 10 weeks of learning programming, we are able to create a functioning website with the most common features implemented, namely:
    * Devise: signing in, loging in and out features
    * ActionMailer: sending various emails to users (e.g: after signing up, after booking a class, etc.)
    * Stripe: to handle the payments 

## How to open the website

The quickest and easiest way to do it would be to open it on Heroku: https://knowshare-thp.herokuapp.com/

Or you can run the following commands in your terminal:

1) Clone this repository 
```shell
$ git clone https://github.com/vanaklay/KnowShare
```

2) Prepare the initialization of the repository
```shell
$ bundle install
```

```shell
$ rails db:create
```

```shell
$ rails db:migrate
```

```shell
$ rails db:seed
```

3) Run the app in your server
```shell
$ rails server
```

4) Now all you need to do is open it in your favorite browser

## Authors

@vanaklay
@Mtwod
@Rudyar
@colinebrlt

(special thanks to our fantastic mentor: @MatthieuLPro)