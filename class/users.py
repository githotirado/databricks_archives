class User:
    """Makes a user object"""

    def __init__(self, first_name, last_name, department, manager, height):
        """Initializes the user object"""
        self.first_name = first_name.title()
        self.last_name = last_name.title()
        self.department = department
        self.manager = manager
        self.height = height
        self.login_attempts = 0
    
    def describe_user(self):
        """Print out all user information"""
        print(f"""User Name: {self.first_name} {self.last_name}
        User Department: {self.department}
        User Manager: {self.manager}
        User Height:  {self.height}
        Login attempts: {self.login_attempts}""")

    def greet_user(self):
        """Greet the user"""
        # print(f"Welcome, {self.first_name} {self.last_name}")
        return f"Welcome, {self.first_name} {self.last_name}"

    def increment_login_attempts(self):
        """Increment login attempts by 1"""
        self.login_attempts += 1
    
    def reset_login_attempts(self):
        """reset the login attempts back to zero"""
        self.login_attempts = 0

henry = User("henry", "tirado", "analytics", "Jones", "5.10")
kirk = User("kirk", "wagner", "entertainment", "Plisken", "6.1")
sean = User("sean", "mcVay", "sports", "rampage", "5.11")

henry.describe_user()
print(f"{henry.greet_user()}")
henry.increment_login_attempts()
henry.increment_login_attempts()
henry.increment_login_attempts()
henry.increment_login_attempts()
henry.describe_user()
henry.reset_login_attempts()
henry.describe_user()
# kirk.describe_user()
# print(f"{kirk.greet_user()}")
# sean.describe_user()
# print(f"{sean.greet_user()}")
