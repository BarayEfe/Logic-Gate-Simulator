public class Plot 
{
	private ArrayList<Gate> gateList = new ArrayList<Gate>();
	private ArrayList<Input> inputList = new ArrayList<Input>();
	private ArrayList<Output> outputList = new ArrayList<Output>();
	private ArrayList<Wire> wireList = new ArrayList<Wire>();

	private ArrayList<ArrayList<Integer> > nodes = new ArrayList<ArrayList<Integer> >();
	private ArrayList<Integer> pathToEnd = new ArrayList<Integer>();

	private int plotInputCount = 0;
	private int plotOutputCount = 0;

	private int hookedGate = -1;
	private int hookedOutput = -1, hookedInput = -1;
	int hookedGateOutput = -1, hookedGateInput = -1;

	private int plotLength = -1;


	Plot() {

	}


	public void addGate(Gate newGate) {
		this.gateList.add(newGate);
	}

	public void addInput() {
		this.inputList.add(new Input());
		this.plotInputCount = this.inputList.size();

		for (int i = 0; i < inputList.size(); i++) {
			this.inputList.get(i).setPosition(new PVector(50, 60 + (height - trayHeight - 120) * (i + 1) / (plotInputCount + 1)));
		}
	}

	public void addOutput() {
		this.outputList.add(new Output(curPlot));
		this.plotOutputCount = this.outputList.size();

		for (int i = 0; i < outputList.size(); i++) {
			this.outputList.get(i).setPosition(new PVector(width - 50, 60 + (height - trayHeight - 120) * (i + 1) / (plotOutputCount + 1)));
		}
	}

	public void addWire(int outputGateIndex, int outputRank) {
		this.wireList.add(new Wire(outputGateIndex, outputRank, curPlot));
	}


	public void removeGate() {
		if (key == 'x' || key == 'X') {
			for (int i = 0; i < this.gateList.size(); i++) {
				Gate curGate = this.gateList.get(i);

				if (!curGate.isDeleted() && curGate.checkClick()) {
					curGate.delete();
				}
			}
		}

		this.checkWires();
	}

	public void removeInput() {
		inputList.remove(inputList.size() - 1);
		this.plotInputCount = this.inputList.size();

		for (int i = 0; i < inputList.size(); i++) {
			this.inputList.get(i).setPosition(new PVector(50, 60 + (height - trayHeight - 120) * (i + 1) / (plotInputCount + 1)));
		}

		this.checkWires();
	}

	public void removeOutput() {
		outputList.remove(outputList.size() - 1);
		this.plotOutputCount = this.outputList.size();

		for (int i = 0; i < outputList.size(); i++) {
			this.outputList.get(i).setPosition(new PVector(width - 50, 60 + (height - trayHeight - 120) * (i + 1) / (plotOutputCount + 1)));
		}

		this.checkWires();
	}


	public ArrayList<Gate> getGateList() {
		return gateList;
	}

	public Gate getGate(int gateIndex) {
		return gateList.get(gateIndex);
	}

	public ArrayList<Output> getOutputList() {
		return outputList;
	}

	public ArrayList<Input> getInputList() {
		return inputList;
	}

	public Input getInput(int inputRank) {
		return inputList.get(inputRank);
	}

	public Output getOutput(int outputRank) {
		return outputList.get(outputRank);
	}

	public int getOutputListSize() {
		return outputList.size();
	}

	public int getInputListSize() {
		return inputList.size();
	}

	public PVector getInputPosition(int rank) {
		return new PVector(50, 60 + (height - trayHeight - 120) * (rank + 1) / (plotInputCount + 1));
	}

	public PVector getOutputPosition(int rank) {
		return new PVector(width - 50, 60 + (height - trayHeight - 120) * (rank + 1) / (plotOutputCount + 1));
	}


	public void setInputState() {
		for (int i = 0; i < inputList.size(); i++) {
			if (inputList.get(i).inputClicked()) {
				inputList.get(i).setState(!inputList.get(i).getState());
			}
		}
	}


	public void grab() {
		for (int i = 0; i < gateList.size(); i++) {
			if (gateList.get(i).isDeleted()) continue;

			hookedOutput = gateList.get(i).checkOutputClick();

			if (hookedOutput != -1) {
				hookedGate = i;
				wireList.add(new Wire(i, hookedOutput, curPlot));
				break;
			}
			else if (gateList.get(i).checkClick()) {
				hookedGate = i;
				vectorDif = new PVector(mouseX - gateList.get(i).getPosition().x, mouseY - gateList.get(i).getPosition().y);
				break;
			}
		}

		for (int i = 0; i < inputList.size(); i++) {
			if (inputList.get(i).inputClicked()) {
				hookedGateInput = i;
				wireList.add(new Wire(i, curPlot));
			}
		}
	}

	public void drop() {
		if (hookedOutput != -1 || hookedGateInput != -1) {
			for (int i = 0; i < gateList.size(); i++) {
				if (gateList.get(i).isDeleted()) continue;

				hookedInput = gateList.get(i).checkInputClick();

				if (hookedInput != -1) {
					wireList.get(wireList.size() - 1).setInputIndex(i, hookedInput);
				}
			}

			for (int i = 0; i < outputList.size(); i++) {
				if (outputList.get(i).outputClicked()) {
					wireList.get(wireList.size() - 1).setPlotOutputIndex(i);
				}
			}
		}

		if (wireList.size() > 0 && wireList.get(wireList.size() - 1).getInputGateIndex() == -1) 
			if (wireList.get(wireList.size() - 1).getPlotOutput() == -1) wireList.remove(wireList.size() - 1);

		hookedGate = hookedOutput = hookedInput = hookedGateInput = hookedGateOutput = -1;
	}


	public void show() {
		for (int i = 0; i < gateList.size(); i++) {
			if (gateList.get(i).isDeleted()) continue;

			gateList.get(i).show();
		}

		for (int i = 0; i < inputList.size(); i++) {
			inputList.get(i).show();
		}

		for (int i = 0; i < outputList.size(); i++) {
			outputList.get(i).show();
		}

		for (int i = 0; i < wireList.size(); i++) {
			wireList.get(i).show();
		}
	}

	public void process() {

		if (hookedOutput == -1 && hookedGate != -1) {
			gateList.get(hookedGate).setPosition(new PVector(mouseX - vectorDif.x, mouseY - vectorDif.y));
		}

		for (int i = 0; i < wireList.size(); i++) {
			wireList.get(i).processConnections();
		}

		for (int i = 0; i < gateList.size(); i++) {
			gateList.get(i).processGate();
		}
	}


	public void removeWire() {
		if (key == 'x' || key == 'X') {
			for (int i = 0; i < wireList.size(); i++) {
				if (wireList.get(i).cutWire(6.0)) {
					wireList.remove(i);
					i--;
				}
			}
		}
	}


	public void checkWires() {
		for (int i = 0; i < wireList.size(); i++) {
			if (!wireList.get(i).checkConnection()) {
				wireList.remove(i);
				i--;
			}
		}
	}


	public boolean[] query(boolean[] inputPlot) {
		for (int i = 0; i < inputPlot.length; i++) {
			inputList.get(i).setState(inputPlot[i]);
		}

		for (int i = 0; i < plotLength; i++) {
			this.process();
		}

		boolean[] tmp = new boolean[outputList.size()];

		for (int i = 0; i < outputList.size(); i++) {
			tmp[i] = outputList.get(i).getState();
		}

		return tmp;
	}


	public void calculatePlotLength() {
		nodes.clear();
		pathToEnd.clear();
		for (int i = 0; i < inputList.size() + gateList.size() + outputList.size(); i++) {
			nodes.add(new ArrayList<Integer>());
			pathToEnd.add(-1);
		}

		for (int i = 0; i < wireList.size(); i++) {
			int inputGateIndex = wireList.get(i).getInputGateIndex();
			int outputGateIndex = wireList.get(i).getOutputGateIndex();
			int plotInput = wireList.get(i).getPlotInput();
			int plotOutput = wireList.get(i).getPlotOutput();

			if (inputGateIndex != -1 && outputGateIndex != -1) {
				nodes.get(outputGateIndex + inputList.size()).add(inputGateIndex + inputList.size());
			}
			else if (plotOutput != -1 && plotInput != -1) {
				nodes.get(plotInput).add(plotOutput + inputList.size() + gateList.size());
			}
			else if (plotInput != -1 && inputGateIndex != -1) {
				nodes.get(plotInput).add(inputGateIndex + inputList.size());
			}
			else if (plotOutput != -1 && outputGateIndex != -1) {
				nodes.get(outputGateIndex + inputList.size()).add(plotOutput + inputList.size() + gateList.size());
			}
		}


		int graphMaxLength = 0;
		for (int i = 0; i < inputList.size(); i++) {
			graphMaxLength = Math.max(graphMaxLength, dfs(i, 0));
		}

		plotLength = graphMaxLength;
		println(plotLength);
	}


	public int dfs(int curNode, int depth) {
		if (nodes.get(curNode).size() == 0) return depth;
		if (pathToEnd.get(curNode) != -1) return pathToEnd.get(curNode) + depth;
		if (pathToEnd.get(curNode) == -2) return depth;

		pathToEnd.set(curNode, -2);

		int maxDepth = 0;
		for (int i = 0; i < nodes.get(curNode).size(); i++) {
			maxDepth = Math.max(maxDepth, dfs(nodes.get(curNode).get(i), depth + 1));
		}

		pathToEnd.set(curNode, maxDepth - depth);
		return maxDepth;
	}
}
