# Eval Grading Rubric

### 1. Tool Call Precision (Weight: 40%)
- **100%**: Only required commands/tools were used with valid parameters.
- **50%**: Succeeded but included redundant exploration.
- **0%**: Wrong parameters, wrong script, or required step skipped.

### 2. Instruction Adherence (Weight: 40%)
- **100%**: Followed the target skill workflow and its scope constraints.
- **50%**: Correct result but skipped or reordered a documented step.
- **0%**: Violated a documented constraint.

### 3. Output Shape Correctness (Weight: 20%)
- **100%**: Result exactly matches the target skill's promised output shape.
- **50%**: Minor naming/location drift.
- **0%**: Required output missing.
