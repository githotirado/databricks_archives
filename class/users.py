class User:
    """Makes a user object"""

    def __init__(self, first_name, last_name, department, manager, height):
        """Initializes the user object"""
        self.first_name = first_name.title()
        self.last_name = last_name.title()
        self.department = department
        self.manager = manager
        self.height = height
    
    def describe_user(self):
        """Print out all user information"""
        print(f"""User First Name: {self.first_name}
        User Last Name: {self.last_name}
        User Department: {self.department}
        User Manager: {self.manager}
        User Height:  {self.height}""")

    def greet_user(self):
        """Greet the user"""
        print(f"Welcome, {self.first_name} {self.last_name}")

henry = User("henry", "tirado", "analytics", "Jones", "5.10")
kirk = User("kirk", "wagner", "entertainment", "Plisken", "6.1")
sean = User("sean", "mcvay", "sports", "rampage", "5.11")

henry.describe_user()
henry.greet_user()
kirk.describe_user()
kirk.greet_user()
sean.describe_user()
sean.greet_user()