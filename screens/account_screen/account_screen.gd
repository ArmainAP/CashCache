extends Control

onready var header_label = $VBoxContainer/Header/HBoxContainer/ResizeableLabel
onready var chart: Chart = $VBoxContainer/Body/Panel/VBoxContainer/Chart

# This Chart will plot 3 different functions
var f1: Function

func _ready():
	header_label.text = Time.get_date_string_from_system()
	
	# Let's create our @x values
	var x: Array = [50, 50, 50]
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = ["C++", "GDScript", "Java"]
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.transparent
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.whitesmoke
	cp.draw_bounding_box = false
	cp.title = "Users preferences on programming languages"
	cp.draw_grid_box = false
	cp.show_legend = true
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color.aquamarine)
	gradient.set_color(1, Color.deeppink)
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Language", # This will create a function with x and y values taken by the Arrays 
						  # we have created previously. This function will also be named "Pressure"
						  # as it contains 'pressure' values.
						  # If set, the name of a function will be used both in the Legend
						  # (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		{
			gradient = gradient,
			type = Function.Type.PIE
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
