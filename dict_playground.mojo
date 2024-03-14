from collections.dict import Dict, KeyElement, DictEntry


@value
struct StringKey(KeyElement):
    var s: String

    fn __init__(inout self, owned s: String):
        self.s = s ^

    fn __init__(inout self, s: StringLiteral):
        self.s = String(s)

    fn __hash__(self) -> Int:
        return hash(self.s)

    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s


trait TPet:
    fn __init__(inout self, name: String):
        pass

    fn __copyinit__(inout self, existing: Self):
        pass

    fn __moveinit__(inout self, owned existing: Self):
        pass

    fn __del__(owned self):
        pass

    fn name(self) -> String:
        pass

    fn start(self, edible: String):
        pass


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

    # var d = Dict[StringKey, CollectionElement]()
    var d = Dict[StringKey, Pet]()

    # var de_cats = DictEntry(StringKey(cats), my_cats)
    # var de_dogs = DictEntry(StringKey(dogs), my_dogs)

    # d.__setitem__(StringKey(cats), my_cats)

    # d[cats] = my_cats
    # d[dogs] = my_dogs

    # print(len(d))  # prints 2
    # print(d[cats].name)  # prints 1
    # print(d.pop(dogs).name)  # prints 2
    # print(len(d))  # prints 1
