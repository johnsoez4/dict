from collections.dict import Dict, KeyElement, DictEntry


trait TPet:
    fn __init__(inout self, name: String):
        ...

    fn __copyinit__(inout self, existing: Self):
        ...

    fn __moveinit__(inout self, owned existing: Self):
        ...

    fn __del__(owned self):
        ...

    fn name(self) -> String:
        ...

    fn start(self, edible: String):
        ...


struct MyPet(TPet):
    var _name: String

    fn __init__(inout self, name: String):
        self._name = name

    fn __copyinit__(inout self, existing: Self):
        self._name = existing._name

    fn __moveinit__(inout self, owned existing: Self):
        self._name = existing._name

    fn __del__(owned self):
        pass

    fn name(self) -> String:
        return self._name

    fn start(self, edible: String):
        self.drink(edible)

    fn drink(self, liquid: String):
        print(self._name, "drink", liquid)


struct YourPet(TPet):
    var _name: String

    fn __init__(inout self, name: String):
        self._name = name

    fn __copyinit__(inout self, existing: Self):
        self._name = existing._name

    fn __moveinit__(inout self, owned existing: Self):
        self._name = existing._name

    fn __del__(owned self):
        pass

    fn name(self) -> String:
        return self._name

    fn start(self, edible: String):
        self.eat(edible)

    fn eat(self, food: String):
        print(self._name, "eat", food)


@value  # <-- Added 2024-03-14 EzRyder
struct Pet[T: TPet](CollectionElement):
    var name: String
    var pet: T

    fn __init__(inout self, name: String, pet: T):
        self.name = name
        self.pet = pet

    fn __copyinit__(inout self, existing: Self):
        self.name = existing.name
        self.pet = existing.pet

    fn __moveinit__(inout self, owned existing: Self):
        self.name = existing.name
        self.pet = existing.pet

    fn __del__(owned self):
        pass

    fn start(self, edible: String):
        self.pet.start(edible)


fn main() raises:
    alias cats = "Cats"
    alias dogs = "Dogs"

    var my_pet = MyPet(cats)
    var your_pet = YourPet(dogs)

    var my_cats = Pet(cats, my_pet)
    my_cats.start("champagne.")

    var my_dogs = Pet(dogs, your_pet)
    my_dogs.start("blueberries.")

    # var d = Dict[StringKey, CollectionElement]()  # Compiler crashes
    var d = Dict[String, Pet[MyPet]]()  # Only works for MyPet, not YourPet
    # var d = Dict[String, Pet[TPet]]()  # Error here

    d[cats] = my_cats
    d[dogs] = my_dogs

    print(len(d))  # prints 2
    print(d[cats].name)  # prints 1
    d[cats].start("iced tea.")
    print(d.pop(dogs).name)  # prints 2
    print(len(d))  # prints 1
