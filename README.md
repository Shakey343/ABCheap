![ABCheap logo](https://github.com/Shakey343/ABCheap/blob/master/app/assets/images/ABCheap-no-background.png)
> # Making affordable travel easy!

---

### Table of contents

- [Description](#description)
- [How To Use](#how-to-use)
- [Author Info](#author-info)

---

## Description

An inter-city travel app that produces the best options given a window of flexibility with a focus on money saving. The app will search for all travel options from national rail and coach travel within a window which can either be specified by the user or not, in which case the app will apply its default window. The app also allows the user to include whether they have a railcard and/or access to a car, which will then be factored into the search. Three main options are presented, the fastest, cheapest and recommended. The recommended journey is equated by a value system that adds cost to the jounrey for duration and deviation from the users preferred time. There are then 3 other options offered as a further options feature. The user is then able to book and pay for these journies and keep track of all past and future journies in their account profile.

#### Technologies

- Ruby on Rails.
- Mapbox API - Used for geolocating and mapping out the users journey.
- Stripe - To process payments.
- Web Scraping - Currently we are using web scraping to retrieve real time travel information. The hope is to be able to use a more efficient API in future.

---
## How To Use

#### Intallation

Run an install on the gems used.

```sh
bundle install
```

#### API Reference

To use mapbox & stripe ensure you have included your keys in the `.ENV` file.

To create a `.ENV` file run this command in the main directory of the app.

```sh
touch .env
```
Copy your keys directly into the file (for stripe make sure you also copy your sectret key).

```
MAPBOX_API_KEY=pk.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxxxxxxxxxxxxx
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxxxxxxxxxxxxx
```

## Author Info

Dveloped by:
##### Alex Taylor
-[Linked In](#)

##### Jake Pople
-[Linked In](#)

##### Henrique Langnas
-[Linked In](#)

##### Ashton Charge
-[Linked In](https://www.linkedin.com/in/ashton-charge-a68839234/)

[Back to the top](ABCheap)


