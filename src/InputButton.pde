public class IOButton 
{
	private PVector position;
	private PVector dimensions;
	color col;

	IOButton(PVector position, PVector dimensions, color col) {
		this.position = position;
		this.dimensions = dimensions;
		this.col = col;
	}

	public void show() {
		strokeWeight(1);
		stroke(255);
		fill(60);

		rect(position.x, position.y, dimensions.x, dimensions.y, 10, 10, 10, 10);
	}

	public boolean checkClick() {
		boolean b1 = (mouseX >= position.x) && (mouseX <= position.x + dimensions.x);
		boolean b2 = (mouseY >= position.y) && (mouseY <= position.y + dimensions.y);

		if (b1 && b2) return true;
		return false;
	}
}
