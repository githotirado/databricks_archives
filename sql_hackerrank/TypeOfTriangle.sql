SELECT CASE 
    WHEN A = B AND A = C THEN 'Equilateral'
    WHEN (A + B) <= C  or (B + C) <= A or (A + C) <= B THEN 'Not A Triangle'
    WHEN A = B or A = C or B =  C THEN 'Isosceles'
    WHEN A <> B AND A <> C AND B <> C THEN 'Scalene'
    END AS TriangleType
FROM triangles;