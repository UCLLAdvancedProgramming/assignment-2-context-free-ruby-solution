# Common mistakes

<!-- fork -->
## Incomplete solution to the "forks" example

One way to solve the issue with fork when you're using `method_missing` to
implement shape definitions could be to define a separate `fork` method.

This fixes the forks example. However, if we try to do it with another method
from
[`Kernel`](https://ruby-doc.org/3.3.1/Kernel.html),
e.g.
[`spawn`](https://ruby-doc.org/3.3.1/Kernel.html#method-i-spawn),
we get the same problem.

A better solution involves not using `method_missing`, but instead opting to
use `define_method` or `define_singleton_method` for every shape that was defined.

<!-- method_missing -->
## Abuse of `method_missing` for primitive shapes

You might be tempted to use `method_missing` to handle `square` and `triangle`, like:

```ruby
def method_missing(name, *args, **kwargs)
  if name == :triangle || name == :square
    @primitive_shapes << Shape.new(name, @properties.adjust(Adjustment.new(**kwargs)))
  else
    super
  end
end
```

It's pretty hacky to `method_missing` in this way. If you already
know beforehand that you'll need a `square` and a `triangle` method,
then it's perfectly fine to just use `def square` and `def triangle`:

```ruby
def square(**kwargs)
  @primitive_shapes << Shape.new(:square, @properties.adjust(Adjustment.new(**kwargs)))
end

def triangle(**kwargs)
  @primitive_shapes << Shape.new(:triangle, @properties.adjust(Adjustment.new(**kwargs)))
end
```

If you want to eliminate the repetition you could use `define_method`:

```ruby
[:square, :triangle].each do |name|
  define_method name do |**kwargs|
    @primitive_shapes << Shape.new(name, @properties.adjust(Adjustment.new(**kwargs)))
  end
end
```

Another (and arguably cleaner) way would be to simply introduce an extra method:

```ruby
def square(**kwargs)
  add_primitive_shape(:square, **kwargs)
end

def triangle(**kwargs)
  add_primitive_shape(:triangle, **kwargs)
end

def add_primitive_shape(name, **kwargs)
  @primitive_shapes << Shape.new(new, @properties.adjust(Adjustment.new(**kwargs)))
end
```

<!-- kwargs -->
## Copying of keyword arguments one by one

You could name every single keyword argument one by one if you want
to create an `Adjustment` object, and then you'd have to change every
single part of your code that creates an `Adjustment` object should you
ever want to add an extra adjustment (e.g. Context Free Art has a `flip`
adjustment).

The code that creates the `Adjustment` doesn't really care what properties
the `Adjustment` class has. The only classes that have to care about
that are `Adjustment` and `Properties`.

Using `**`, you can just pass the keyword arguments to the constructor
of `Adjustment`, e.g.:

```ruby
def square(**kwargs)
  @primitive_shapes << Shape.new(:square, @properties.adjust(Adjustment.new(**kwargs)))
end
```

<!-- instance_eval -->
## Use of `instance_eval` without a proper context

When using `instance_eval` to evaluate a block, it's important to consider
what the object is that you're calling `instance_eval` on. When evaluating
the block that corresponds to a rule, which object is appropriate?

It's not appropriate to evaluate it directly inside of the context of
the `DSL` module, but it's not very clean to evaluate it inside
of `Grammar` either. It's much nicer to create a completely separate
object. One that's entirely for the purpose of providing a context for a
rule to be evaluated in.

This context needs to keep track of all of the shapes our rule generates,
and has to provide appropriate methods in order to make that work. See
`RuleContext` in the model solution for an example.
