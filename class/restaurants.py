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
    
    def describe_restaurant(self):
        """Sets forth a restaurant description"""
        print(f"The restaurant {self.restaurant_name} serves {self.cuisine_type} food.")

    def open_restaurant(self):
        """Method to open a restaurant that might be closed"""
        print(f"The restaurant {self.restaurant_name} is open.")

restaurant1 = Restaurant("La Boheme", "French")
restaurant2 = Restaurant("Mario's", "Peruvian")
restaurant3 = Restaurant("El Morfi", "Argentine")

print(f"Manual invocation: {restaurant1.restaurant_name} serves {restaurant1.cuisine_type} food")
restaurant1.describe_restaurant()
restaurant1.open_restaurant()

restaurant2.describe_restaurant()
restaurant3.describe_restaurant()