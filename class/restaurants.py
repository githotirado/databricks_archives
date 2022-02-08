import os

"""Make a class called Restaurant
The class should store attributes restaurant_name and cuisine_type
Add a method called describe_restaurant that prints the information
Add a method called open_restaurant to indicate that the resturant is open
Later, create instance called restaurant Print the attributes, then call the functions
"""
class Restaurant:
    """Simple restaurant object created"""
    def __init__(self, restaurant_name, cuisine_type):
        """Makes restaurant objects with name and cuisine type"""
        self.restaurant_name = restaurant_name
        self.cuisine_type = cuisine_type
        self.number_served = 0
    
    def describe_restaurant(self):
        """Sets forth a restaurant description"""
        print(f"The restaurant {self.restaurant_name} serves {self.cuisine_type} food.")

    def open_restaurant(self):
        """Method to open a restaurant that might be closed"""
        print(f"The restaurant {self.restaurant_name} is open.")

    def set_number_served(self, ns):
        """Hard set of number served"""
        self.number_served = ns

    def increment_number_served(self, inc_number):
        """Dynamically increment number served"""
        self.number_served += inc_number

class IceCreamStand(Restaurant):
    """A specific type of restaurant inherited from Restaurant"""
    def __init__(self, restaurant_name, cuisine_type):
        """Initialize this class with parent class attributes"""
        super().__init__(restaurant_name, cuisine_type)
        self.flavors = ['vanilla', 'chocolate', 'mint chocolate chip', 'strawberry']

    def display_flavors(self):
        print(f"Flavors at this establishment: {self.flavors}")

# restaurant1 = Restaurant("La Boheme", "French")
# restaurant2 = Restaurant("Mario's", "Peruvian")
# restaurant3 = Restaurant("El Morfi", "Argentine")

# Exercise 9-4
# restaurant1.describe_restaurant()
# print(f"Number served: {restaurant1.number_served}")
# restaurant1.number_served = 72
# print(f"New number served: {restaurant1.number_served}")
# restaurant1.set_number_served(54)
# print(f"Newest number served is {restaurant1.number_served}")
# my_inc = 12
# restaurant1.increment_number_served(my_inc)
# print(f"Incremented number by {my_inc} resulting in {restaurant1.number_served}")

# print(f"Manual invocation: {restaurant1.restaurant_name} serves {restaurant1.cuisine_type} food")
# restaurant1.describe_restaurant()
# restaurant1.open_restaurant()

# Exercise 9-1, 9-2
# restaurant2.describe_restaurant()
# restaurant3.describe_restaurant()

# Exercise 9-6
ice_cream = IceCreamStand("31 Flavors", "Ice Cream")
ice_cream.describe_restaurant()
ice_cream.display_flavors()