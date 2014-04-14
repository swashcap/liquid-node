describe "Liquid.Condition", ->
  context "if", ->
    it "renders on `true` variables", ->
      renderTest('X', '{% if var %}X{% endif %}', var: true)

    it "doesn't render on `false` variables", ->
      renderTest('', '{% if var %}X{% endif %}', var: false)

    it "renders on truthy variables", ->
      renderTest('X', '{% if var %}X{% endif %}', var: "abc")

    it "doesn't render on falsy variables", ->
      renderTest('', '{% if var %}X{% endif %}', var: null)

    it "renders on truthy object properties", ->
      renderTest('X', '{% if foo.bar %}X{% endif %}', foo: { bar: "abc" })

    it "doesn't render on falsy object properties", ->
      renderTest('', '{% if foo.bar %}X{% endif %}', foo: { bar: null })

    it "renders on truthy constants", ->
      renderTest('X','{% if "foo" %}X{% endif %}')

    it "doesn't render on falsy constants", ->
      renderTest('','{% if null %}X{% endif %}', null: 42)

    context "with condition", ->
      it "(true or true) renders", ->
        renderTest('X','{% if a or b %}X{% endif %}', a: true, b: true)

      it "(true or false) renders", ->
        renderTest('X','{% if a or b %}X{% endif %}', a: true, b: false)

      it "(false or true) renders", ->
        renderTest('X','{% if a or b %}X{% endif %}', a: false, b: true)

      it "(true or true) doesn't render", ->
        renderTest('', '{% if a or b %}X{% endif %}', a: false, b: false)

    context "with operators", ->
      it "that evaluate to true renders", ->
        renderTest 'X','{% if a == 42 %}X{% endif %}', a: 42

      it "that evaluate to false doesn't render", ->
        renderTest '','{% if a != 42 %}X{% endif %}', a: 42

    context "with awful markup", ->
      it "renders correctly", ->
        awful_markup = "a == 'and' and b == 'or' and c == 'foo and bar' and d == 'bar or baz' and e == 'foo' and foo and bar"
        assigns = {'a': 'and', 'b': 'or', 'c': 'foo and bar', 'd': 'bar or baz', 'e': 'foo', 'foo': true, 'bar': true}
        renderTest(' YES ',"{% if #{awful_markup} %} YES {% endif %}", assigns)

    context "with else-branch", ->
      it "renders else-branch on falsy variables", ->
        renderTest 'ELSE', '{% if var %}IF{% else %}ELSE{% endif %}', var: false

      it "renders if-branch on truthy variables", ->
        renderTest 'IF', '{% if var %}IF{% else %}ELSE{% endif %}', var: true

  describe "unless", ->
    it "negates 'false'", ->
      renderTest(' TRUE ','{% unless false %} TRUE {% endunless %}')

    it "negates 'true'", ->
      renderTest('','{% unless true %} FALSE {% endunless %}')

    it "supports else", ->
      renderTest(' TRUE ','{% unless true %} FALSE {% else %} TRUE {% endunless %}')
