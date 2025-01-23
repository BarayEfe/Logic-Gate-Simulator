public class Gate 
{
	private String gateName;
	int plotNum;
	private PVector gatePosition;
	private PVector gateDimensions;
	private int inputCount;
	private int outputCount;
	private color gateColor;
	private boolean deleted = false;

	private boolean[] inputStates;
	private boolean[] outputStates;


	public Gate(String gateName, int plotNum, PVector gatePosition, PVector gateDimensions) {
		this.gateName = gateName;
		this.plotNum = plotNum;
		this.gatePosition = gatePosition;
		this.gateDimensions = gateDimensions;
		this.inputCount = 1;
		this.outputCount = 1;
		this.gateColor = color(100);

		inputStates = new boolean[]{false};
		outputStates = new boolean[]{false};
	}

	public Gate(String gateName, int plotNum, PVector gatePosition, PVector gateDimensions, int inputCount, int outputCount) {
		this.gateName = gateName;
		this.plotNum = plotNum;
		this.gatePosition = gatePosition;
		this.gateDimensions = gateDimensions;
		this.inputCount = inputCount;
		this.outputCount = outputCount;
		this.gateColor = color(100);

		inputStates = new boolean[inputCount];
		for (int i = 0; i < inputCount; i++) inputStates[i] = false;

		outputStates = new boolean[outputCount];
		for (int i = 0; i < outputCount; i++) outputStates[i] = false;
	}

	public void setColor(color gateColor) {
		this.gateColor = gateColor;
	}

	public void setPosition(PVector gatePosition) {
		this.gatePosition = gatePosition;
	}

	public void setState(boolean state, int inputRank) {
		if (inputRank < inputStates.length) {
			inputStates[inputRank] = state;
		}
	}

	public String getName() {
		return gateName;
	}

	public PVector getPosition() {
		return gatePosition;
	}

	public PVector getOutputPosition(int outputRank) {
		return new PVector(gatePosition.x + gateDimensions.x, gatePosition.y + (outputRank + 0.5) * gateDimensions.y / outputCount);
	}

	public PVector getInputPosition(int inputRank) {
		return new PVector(gatePosition.x, gatePosition.y + (inputRank + 0.5) * gateDimensions.y / inputCount);
	}

	public boolean getState(int outputRank) {
		if (outputRank >= outputCount) return false;
		return outputStates[outputRank];
	}

	public void delete() {
		this.deleted = true;
	}

	public boolean isDeleted() {
		if (deleted) return true;
		return false;
	}


	public void processGate() {
		if (this.gateName == "NOT") {
			outputStates[0] = !inputStates[0];
		}
		else if (this.gateName == "AND") {
			outputStates[0] = inputStates[0] && inputStates[1];
		}
		else {
			outputStates = plotList.get(Integer.valueOf(gateName)).query(inputStates);
		}
	}

	public void show() {
		fill(gateColor);
		strokeWeight(1);
		rect(gatePosition.x, gatePosition.y, gateDimensions.x, gateDimensions.y, 10, 10, 10, 10);

		strokeWeight(1);
		for (int i = 0; i < inputCount; i++) {
			if (inputStates[i]) fill(200, 0, 20);
			else fill(60);
			ellipse(gatePosition.x, gatePosition.y + (i + 0.5) * gateDimensions.y / inputCount, 20, 20);
		}

		for (int i = 0; i < outputCount; i++) {
			if (outputStates[i]) fill(200, 0, 20);
			else fill(60);
			ellipse(gatePosition.x + gateDimensions.x, gatePosition.y + (i + 0.5) * gateDimensions.y / outputCount, 20, 20);
		}
	}


	public boolean checkClick() {
		boolean checkX = (mouseX >= gatePosition.x && mouseX <= gatePosition.x + gateDimensions.x);
		boolean checkY = (mouseY >= gatePosition.y && mouseY <= gatePosition.y + gateDimensions.y);

		if (checkX && checkY) {
			return true;
		}
		return false;
	}

	public int checkOutputClick() {
		for (int i = 0; i < outputCount; i++) {
			if (20 >= dist(mouseX, mouseY, gatePosition.x + gateDimensions.x, gatePosition.y + (i + 0.5) * gateDimensions.y / outputCount)) {
				return i;
			}
		}
		return -1;
	}

	public int checkInputClick() {
		for (int i = 0; i < inputCount; i++) {
			if (20 >= dist(mouseX, mouseY, gatePosition.x, gatePosition.y + (i + 0.5) * gateDimensions.y / inputCount)) {
				return i;
			}
		}
		return -1;
	}
}
