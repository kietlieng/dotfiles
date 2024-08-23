#!/opt/homebrew/opt/python@3.11/libexec/bin/python

from wonderwords import RandomWord

foodVerbs = ["added", "baked", "basted", "beated", "blanched", "blended", "boiled", "boned", "braised", "breaded", "brined", "broiled", "browned", "buttered", "caramelized", "carved", "chilled", "choped", "clarifyed", "coated", "cooked", "cored", "creamed", "crimped", "crushed", "cubed", "cured", "cuted", "deboned", "deglazed", "dehydrated", "diced", "dissolved", "dressed", "drizzled", "dusted", "fermented", "filleted", "flambéed", "fliped", "folded", "freezed", "frosted", "fryed", "garnished", "glazed", "grated", "greased", "grilled", "grinded", "kneaded", "layered", "macerated", "marinated", "mashed", "melted", "microwaved", "minced", "mixed", "parboiled", "peeled", "pickled", "pinched", "pited", "poached", "pounded", "poured", "preserved", "pressure-cooked", "proofed", "pureed", "reduced", "reheated", "roasted", "rolled", "sauted", "sautéed", "scalded", "scored", "scrambled", "seared", "seasoned", "separated", "shelled", "shreded", "sifted", "simmered", "skewered", "skimed", "sliced", "slow-cooked", "smoked", "soaked", "spooned", "spreaded", "sprinkled", "steamed", "steeped", "stewed", "stired", "stir-fryed", "strained", "stuffed", "tenderized", "thickened", "toasted", "tossed", "trimed", "whiped", "whisked", "zested"]
foodNouns = ["baked goods", "breads", "cereals", "legumes", "meat", "eggs", "rice", "seafood", "appetizers", "condiments", "confectionery", "convenience foods", "desserts", "dips, pastes and spreads", "dried foods", "dumplings", "fast food", "fermented foods", "halal food", "kosher food", "noodles", "pies", "salads", "sandwiches", "sauces", "snack foods", "soups", "stews", "lomo saltado", "biscuits", "cookie", "cracker", "ginger snap", "hardtack", "abernethy", "acıbadem kurabiyesi", "afghan biscuits", "alfajor", "almond biscuit", "lebkuchen", "aachener printen", "cornish fairing", "speculaas", "springerle", "kruidnoten", "bread", "bagel", "bialy", "croissant", "baguette", "toast", "burrito", "cabbage", "cabbage roll", "cake", "cheesecake", "chocolate cake", "carrot cake", "strawberry cake", "ice-cream cake", "vanilla cake", "red velvet cake", "cupcake", "fudge cake", "list of cakes", "chocolate", "pancake", "poundcake", "chopped liver", "cheese", "mozzarella", "brie", "feta", "blue cheese", "parmesan", "cheese stick", "cheesestrings", "congee", "donuts", "jam", "sprinkles", "donut holes", "chocolate", "krispy kreme", "dumplings", "arepa", "fun guo", "har gow", "momo (food)", "pierogi", "wonton", "fruits", "apple", "banana", "cantaloupe", "durian", "orange (fruit)", "cherry", "kiwi", "watermelon", "avocado", "apricot", "pear", "pineapple", "strawberry", "blueberry", "raspberry", "french fries", "poutine", "grains", "cereal", "corn", "popcorn", "rice", "chocolate ice cream", "vanilla ice cream", "cookies and cream ice cream", "mint chocolate ice cream", "rocky road ice cream", "biscuit tortoni ice cream", "blue moon ice cream", "queso ice cream", "hokey pokey ice cream", "moose tracks ice cream", "tiger tail ice cream", "strawberry ice cream", "superman ice cream", "spumoni ice cream", "pistachio ice cream", "moon mist ice cream", "neapolitan ice cream", "mashed potatoes", "meats", "beef", "wagyu", "steak", "pork", "bacon", "ham", "poultry", "buffalo wing", "chicken balls", "chicken nuggets", "chicken steak", "chicken feet", "roast chicken", "ribs", "seafood", "fish", "salmon", "shrimp and prawn", "shark", "eggs", "scrambled egg", "sunny side up", "omelette", "boiled egg", "tea egg", "century egg", "iron egg", "smoked egg", "soy egg", "chinese red eggs", "milk", "almond milk", "soy milk", "cow milk", "goat milk", "onion rings", "pasta", "lasagna", "linguini", "ravioli", "carbonara", "bolognese", "spaghetti", "spaghetti and meatballs", "pancit canton", "fettuccine", "pudding", "pupusa", "pie", "shepherds pie", "apple pie", "cream pie", "pumpkin pie", "key lime pie", "peach pie", "pizza", "pepperoni", "hawaiian", "margherita", "rolls", "croquette", "egg roll", "spring roll", "lumpia", "burrito", "sandwiches", "vegetable sandwich", "grilled cheese", "panini", "cheeseburgers", "bacon cheeseburger", "hamburgers", "chicken burger", "hot dogs", "peanut butter and jam sandwich", "submarine sandwich", "soup", "chowder", "clam chowder", "corn chowder", "sinigang", "sushi", "stew", "taco", "tamale", "turnover", "jamaican patty", "waffle", "roti canai"]
foodAdjectives = ["acidic", "aromatic", "bitter", "blah", "bland", "bright", "briny", "buttery", "candied", "chocolatey", "citrusy", "comforting", "cooling", "decadent", "deep", "earthy", "eggy", "filling", "flowery", "fragrant", "fresh", "fruity", "full-bodied", "gamey", "hearty", "herbaceous", "honeyed", "hot", "indulgent", "mellow", "nutty", "peppery", "perfumed", "pickled", "piquant", "pungent", "refreshing", "rich", "robust", "salty", "satisfying", "savory", "sharp", "smoky", "sour", "spiced", "spicy", "strong", "succulent", "sugary", "sweet", "tangy", "tart", "umami", "vibrant", "warm", "woody", "yeasty", "zesty", "zippy", "airy", "blistered", "brittle", "chewy", "chunky", "cloudy", "clumpy", "colorful", "creamy", "crispy", "crunchy", "crusty", "delicate", "dense", "effervescent", "flaky", "flowing", "fluffy", "foamy", "fragile", "frothy", "fudgy", "glassy", "glossy", "grainy", "gritty", "hearty", "juicy", "light", "liquidy", "lumpy", "luscious", "marbled", "moist", "moldy", "molten", "oily", "opaque", "ripe", "runny", "scaly", "shiny", "silky", "smooth", "soaked", "soft", "sparkling", "stiff", "tender", "thick", "thin", "translucent", "underripe", "velvety", "vibrant", "whipped", "air fried", "al dente", "baked", "blanched", "blended", "boiled", "canned", "caramelized", "charred", "chilled", "coated", "deep fried", "dehydrated", "doughy", "dry", "firm", "flaky", "fried", "glazed", "grilled", "infused", "marinated", "medium", "medium-rare", "medium-well", "melty", "overcooked", "pressure cooked", "pureed", "rare", "raw", "roasted", "sautéed", "scorched", "seared", "simmered", "smoked", "smothered", "spongy", "stewed", "sticky", "stir-fried", "stuffed", "tacky", "tender", "toasted", "tough", "velvety", "well-done", "bubbly", "crackly", "fizzly", "popping", "sizzling", "snapping", "delectable", "flavorful", "flavorsome", "healthful", "inviting", "irresistible", "mouthwatering", "tantalizing", "appetizing", "delicious", "good", "healthy", "tasty", "wholesome", "yummy"]
foodDrinks = ["still water", "sparkling water", "mineral water", "flavored water", "orange juice", "apple juice", "grape juice", "cranberry juice", "tomato juice", "vegetable juice", "cola", "lemon-lime soda", "root beer", "ginger ale", "tonic water", "club soda", "black tea", "green tea", "white tea", "oolong tea", "herbal tea", "iced tea", "espresso", "cappuccino", "latte", "americano", "mocha", "cold brew", "frappuccino", "regular milk", "chocolate milk", "milkshake", "lassi", "horchata", "almond milk", "soy milk", "oat milk", "coconut milk", "rice milk", "fruit smoothie", "green smoothie", "protein shake", "gatorade", "powerade", "red bull", "monster", "hot chocolate and cocoa", "virgin mojito", "shirley temple", "virgin pina colada", "kombucha", "kefir", "alcoholic drinks", "lager", "ale", "stout", "porter", "pilsner", "wheat beer", "ipa", "craft beer", "red wine", "white wine", "rosé wine", "sparkling wine", "dessert wine", "whiskey/bourbon", "vodka", "gin", "rum", "tequila", "brandy", "cognac", "absinthe", "martini", "margarita", "mojito", "daiquiri", "old fashioned", "manhattan", "bloody mary", "negroni", "cosmopolitan", "pina colada", "moscow mule", "amaretto", "baileys", "cointreau", "grand marnier", "kahlúa", "sambuca", "sherry", "port", "vermouth", "marsala", "apple cider", "pear cider", "sake", "mead", "angostura bitters", "peychaud’s bitters", "aperitifs", "aperol", "campari", "vermouth", "digestifs", "amaro", "fernet", "grappa", "chai", "mate", "turkish coffee", "thai iced tea", "bubble tea", "aguas frescas", "tepache", "palm wine", "kvass"]

generator = RandomWord(noun=foodNouns, verb=foodVerbs, adjective=foodAdjectives, drink=foodDrinks)

sentNoun      = generator.word(include_categories = ["noun"])
sentVerb      = generator.word(include_categories = ["verb"])
sentAdjective = generator.word(include_categories = ["adjective"])
sentDrink     = generator.word(include_categories = ["drink"])

print(sentAdjective, sentVerb, sentNoun, "and", sentDrink)
