# pyright: reportUnusedExpression=false
a = set("abracadabra")
b = set("alacazam")
a  # unique letters in a
# {"a", "r", "b", "c", "d"}
a - b  # letters in a but not in b
# {"r", "d", "b"}
a | b  # letters in a or b or both
# {"a", "c", "r", "d", "b", "m", "z", "l"}
a & b  # letters in both a and b
# {"a", "c"}
a ^ b  # letters in a or b but not both
# {"r", "d", "b", "m", "z", "l"}
