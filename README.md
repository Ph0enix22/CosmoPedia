# CosmoPedia 🌌

A MySQL-based relational database system for cataloging galaxies, constellations, star systems, stars, planets, moons, asteroids, observatories, and astronomical discoveries.

## Overview

CosmoPedia is a DBMS project designed to model the hierarchical structure of the universe using relational database principles. The database organizes celestial objects and their relationships while maintaining data integrity through primary keys, foreign keys, normalization, and constraints.

The project demonstrates practical implementation of database concepts such as:

* Entity-Relationship (ER) Modeling
* Relational Schema Design
* Database Normalization (1NF, 2NF, 3NF)
* Foreign Key Constraints
* SQL Views
* Aggregate Queries
* Multi-Table Joins

---

## Database Structure

```text
Galaxy
 └── Constellation
      └── Star System
           ├── Star
           │    └── Planet
           │         └── Moon
           │
           └── Asteroid

Observatory
 └── Discovery
```

---

## Features

* Comprehensive celestial object database
* Normalized relational design
* Referential integrity using foreign keys
* Real-world astronomical sample data
* Analytical SQL queries
* Predefined SQL views
* ER Diagram documentation
* Query output demonstrations

---

## Technologies Used

* MySQL 8.0+
* MySQL Workbench

---

## Database Components

### Core Tables

* Galaxy
* Constellation
* Star System
* Star
* Planet
* Moon
* Asteroid
* Observatory
* Discovery

### Views

* `habitable_planets`
* `celestial_lineage`

---

## Included Files

```text
schema/
└── cosmopedia.sql

queries/
└── Demo_Queries.sql

diagrams/
└── ER_Diagram.pdf

screenshots/
└── Query Demonstrations
```

---

## Example Queries

* Retrieve all habitable planets
* List exoplanets
* Display moons orbiting Jupiter
* Count planets around each star
* Group stars by spectral classification
* Identify potentially hazardous asteroids
* Display complete celestial lineage
* Calculate average planetary temperature
* List active observatories
* Retrieve the largest moons

---

## Learning Outcomes

This project demonstrates:

* Database design and modeling
* Normalization techniques
* Foreign key implementation
* Complex SQL querying
* View creation and usage
* Relational database management

---

## Author

Developed by SMJ 🐦‍🔥

CosmoPedia was developed as part of a Database Management Systems (DBMS) academic project.

Responsibilities included database design, relational modeling, normalization, schema implementation, sample data generation, SQL view creation, and analytical query development.
