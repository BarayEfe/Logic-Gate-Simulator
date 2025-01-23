public class Button 
{
	private String buttonLabel;
	private PVector buttonTopLeft;
	private PVector buttonDimensions;
	private color buttonColor;
	private boolean deletable = false, editable = false;

	public Button(String buttonLabel, PVector buttonTopLeft, PVector buttonDimensions, color buttonColor) {
		this.buttonLabel = buttonLabel;
		this.buttonTopLeft = buttonTopLeft;
		this.buttonDimensions = buttonDimensions;
		this.buttonColor = buttonColor;
	}

	public String getLabel() {
		return buttonLabel;
	}

	public color getColor() {
		return this.buttonColor;
	}

	public void setTopLeft(int x, int y) {
		buttonTopLeft.set(x, y);
	}

	public void setEditability(boolean editability) {
		this.editable = editability;
	}

	public void setDeletability(boolean deletability) {
		this.deletable = deletability;
	}

	public void show() {
		fill(buttonColor);
		strokeWeight(3);
		stroke(255);
		rect(buttonTopLeft.x, buttonTopLeft.y, buttonDimensions.x, buttonDimensions.y, 10, 10, 10, 10);

		textFont(robotoFont);
		fill(240);
		text(buttonLabel, buttonTopLeft.x + 10, buttonTopLeft.y + buttonDimensions.y - 10);

		if (deletable) {
			fill(200, 20, 20);
			float y1 = buttonTopLeft.y + buttonDimensions.y / 4;
			rect(buttonTopLeft.x - buttonDimensions.y / 2, y1, buttonDimensions.y / 2, buttonDimensions.y / 2, 5, 5, 5, 5);
		}

		if (editable) {
			fill(20, 200, 20);
			float y1 = buttonTopLeft.y + buttonDimensions.y / 4;
			rect(buttonTopLeft.x + buttonDimensions.x, y1, buttonDimensions.y / 2, buttonDimensions.y / 2, 5, 5, 5, 5);
		}
	}

	public boolean checkClick() {
		boolean checkX = (mouseX >= buttonTopLeft.x && mouseX <= buttonTopLeft.x + buttonDimensions.x);
		boolean checkY = (mouseY >= buttonTopLeft.y && mouseY <= buttonTopLeft.y + buttonDimensions.y);

		if (checkX && checkY) {
			return true;
		}
		return false;
	}

	public boolean checkEditClick() {
		float y1 = buttonTopLeft.y + buttonDimensions.y / 4;
		float x1 = buttonTopLeft.x + buttonDimensions.x;
		boolean checkX = (mouseX >= x1 && mouseX <= x1 + buttonDimensions.y / 2);
		boolean checkY = (mouseY >= y1 && mouseY <= y1 + buttonDimensions.y / 2);

		if (checkX && checkY) {
			return true;
		}
		return false;
	}

	public boolean checkDeleteClick() {
		float y1 = buttonTopLeft.y + buttonDimensions.y / 4;
		float x1 = buttonTopLeft.x - buttonDimensions.y / 2;
		boolean checkX = (mouseX >= x1 && mouseX <= x1 + buttonDimensions.y / 2);
		boolean checkY = (mouseY >= y1 && mouseY <= y1 + buttonDimensions.y / 2);

		if (checkX && checkY) {
			return true;
		}
		return false;
	}
}

public class Input 
{
	PVector inputPosition;
	int radius = 25;
	boolean state = false;

	Input(PVector inputPosition, int radius, boolean state) {
		this.inputPosition = inputPosition;
		this.radius = radius;
		this.state = state;
	}

	Input(int radius, boolean state) {
		this.inputPosition = new PVector(0.0, 0.0);
		this.radius = radius;
		this.state = state;
	}

	Input() {
		this.inputPosition = new PVector(0.0, 0.0);
	}

	public void setPosition(PVector inputPosition) {
		this.inputPosition = inputPosition;
	}

	public void setRadius(int radius) {
		this.radius = radius;
	}

	public void setState(boolean state) {
		this.state = state;
	}


	public boolean getState() {
		return state;
	}
	

	public void show() {
		if (state) {
			fill(200, 0, 20);
		}
		else {
			fill(60);
		}

		strokeWeight(2);
		stroke(255);
		ellipse(inputPosition.x, inputPosition.y, radius, radius);
	}

	public boolean inputClicked() {
		if (radius >= dist(mouseX, mouseY, inputPosition.x, inputPosition.y)) return true;
		return false;
	}
}


public class Output 
{
	PVector outputPosition;
	int plotRank;
	int radius = 25;
	int incomingGateIndex = -1;
	int outputRank = -1;
	boolean state = false;

	//ArrayList<ArrayList<Integer> > wireInfo = new ArrayList<ArrayList<Integer> >();

	Output(int plotRank, PVector outputPosition, int radius) {
		this.plotRank = plotRank;
		this.outputPosition = outputPosition;
		this.radius = radius;
	}

	Output(int plotRank) {
		this.outputPosition = new PVector(0.0, 0.0);
		this.plotRank = plotRank;
	}

	public boolean getState() {
		return state;
	}

	public void setPosition(PVector outputPosition) {
		this.outputPosition = outputPosition;
	}

	public void setState(boolean state) {
		this.state = state;
	}


	public void show() {
		fill(60);

		if (this.state) {
			fill(200, 0, 20);
		}

		strokeWeight(2);
		stroke(255);
		ellipse(outputPosition.x, outputPosition.y, radius, radius);
	}

	public boolean outputClicked() {
		if (radius >= dist(mouseX, mouseY, outputPosition.x, outputPosition.y)) return true;
		return false;
	}
}


public class Wire 
{
	PVector line1, line2;
	int plotRank;
	int outputGateIndex = -1, inputGateIndex = -1;
	int outputRank, inputRank;
	int plotInput = -1, plotOutput = -1;
	boolean state = false;


	Wire(PVector line1, PVector line2, int outputGateIndex, int outputRank, int plotRank) {
		this.line1 = line1;
		this.line2 = line2;
		this.outputGateIndex = outputGateIndex;
		this.outputRank = outputRank;
		this.plotRank = plotRank;
	}

	Wire(int outputGateIndex, int outputRank, int plotRank) {
		this.line1 = new PVector(-1.0, -1.0);
		this.line2 = new PVector(-1.0, -1.0);
		this.outputGateIndex = outputGateIndex;
		this.outputRank = outputRank;
		this.plotRank = plotRank;
	}

	Wire(int plotInput, int plotRank) {
		this.plotInput = plotInput;
		this.plotRank = plotRank;
	}

	Wire(int plotRank) {
		this.plotRank = plotRank;
	}

	Wire() {

	}


	public int getInputGateIndex() {
		return inputGateIndex;
	}

	public int getOutputGateIndex() {
		return outputGateIndex;
	}

	public int getPlotInput() {
		return plotInput;
	}

	public int getPlotOutput() {
		return plotOutput;
	}


	public void setLine1(PVector line1) {
		this.line1 = line1;
	}

	public void setLine2(PVector line2) {
		this.line2 = line2;
	}


	public void setOutputIndex(int outputGateIndex, int outputRank) {
		this.outputGateIndex = outputGateIndex;
		this.outputRank = outputRank;
	}

	public void setInputIndex(int inputGateIndex, int inputRank) {
		this.inputGateIndex = inputGateIndex;
		this.inputRank = inputRank;
	}


	public void setPlotInputIndex(int plotInput) {
		this.plotInput = plotInput;
	}

	public void setPlotOutputIndex(int plotOutput) {
		this.plotOutput = plotOutput;
	}


	public void show() {
		strokeWeight(6);
		stroke(255);

		if (this.state) stroke(250, 50, 50);
	

		if (inputGateIndex == -1 && plotOutput == -1 && outputGateIndex == -1) {
			//println("5");
			line1 = plotList.get(plotRank).getInputPosition(plotInput);
			line2 = new PVector(mouseX, mouseY);
		}
		else if (inputGateIndex == -1 && plotOutput == -1 && plotInput == -1) {
			//println("6: " + outputGateIndex);
			line1 = plotList.get(plotRank).getGateList().get(outputGateIndex).getOutputPosition(outputRank);
			line2 = new PVector(mouseX, mouseY);
		}

		if (inputGateIndex != -1 && outputGateIndex != -1) {
			//println("1: " + outputGateIndex);
			line1 = plotList.get(plotRank).getGateList().get(outputGateIndex).getOutputPosition(outputRank);
			line2 = plotList.get(plotRank).getGateList().get(inputGateIndex).getInputPosition(inputRank);
		}
		else if (plotOutput != -1 && plotInput != -1) {
			//println("2");
			line1 = plotList.get(plotRank).getInputPosition(plotInput);
			line2 = plotList.get(plotRank).getOutputPosition(plotOutput);
		}
		else if (plotInput != -1 && inputGateIndex != -1) {
			//println("3");
			line1 = plotList.get(plotRank).getInputPosition(plotInput);
			line2 = plotList.get(plotRank).getGateList().get(inputGateIndex).getInputPosition(inputRank);
		}
		else if (plotOutput != -1 && outputGateIndex != -1) {
			//println("4");
			line1 = plotList.get(plotRank).getOutputPosition(plotOutput);
			line2 = plotList.get(plotRank).getGateList().get(outputGateIndex).getOutputPosition(outputRank);
		}
		
		line(line1.x, line1.y, line2.x, line2.y);
	}


	public boolean cutWire(float distance) {
		float x1 = line1.x, x2 = line2.x;
		float y1 = line1.y, y2 = line2.y;

		//println(Math.min(x1, x2) + " " + Math.max(x1, x2));

		if (mouseX <= Math.min(x1, x2) || mouseX >= Math.max(x1, x2) || mouseY <= Math.min(y1, y2) || mouseY >= Math.max(y1, y2)) {
			return false;
		}

		float deltaX = Math.abs(mouseY - ((mouseX - x2) / (x1 - x2) * (y1 - y2) + y2));
		float deltaY = Math.abs(mouseX - ((mouseY - y2) / (y1 - y2) * (x1 - x2) + x2));

		//println((deltaX * deltaY) / Math.sqrt(deltaX * deltaX + deltaY * deltaY));

		if (distance >= (deltaX * deltaY) / Math.sqrt(deltaX * deltaX + deltaY * deltaY)) return true;
		return false;
	}


	public boolean checkConnection() {
		//println("in");

		boolean connection1 = false;
		if (inputGateIndex != -1) {
			connection1 = plotList.get(plotRank).getGate(inputGateIndex).isDeleted();
		}

		boolean connection2 = false;
		if (outputGateIndex != -1) {
			connection2 = plotList.get(plotRank).getGate(outputGateIndex).isDeleted();
		}
		
		boolean connection3 = false;
		if (plotInput != -1) {
			connection3 = plotList.get(plotRank).getInputListSize() <= plotInput;
		}

		boolean connection4 = false;
		if (plotOutput != -1) {
			connection4 = plotList.get(plotRank).getOutputListSize() <= plotOutput;
		}
		//println("out");

		if (connection1 || connection2 || connection3 || connection4) {
			return false;
		}
		return true;
	}


	public void processConnections() {
		if (outputGateIndex != -1) {
			this.state = plotList.get(plotRank).getGate(outputGateIndex).getState(outputRank);
		}
		else if (plotInput != -1) {
			//println(plotList.get(plotRank).getInput(plotInput).getState());
			this.state = plotList.get(plotRank).getInput(plotInput).getState();
		}
		
		if (inputGateIndex != -1) {
			plotList.get(plotRank).getGate(inputGateIndex).setState(this.state, inputRank);
		}
		else if (plotOutput != -1) {
			plotList.get(plotRank).getOutput(plotOutput).setState(this.state);
		}
	}
}
