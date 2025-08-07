import pandas as pd

def hex_to_bin_fixed(value):
    """Convert hex string or scientific notation to 16-bit binary."""
    try:
        if isinstance(value, str) and 'E' in value.upper():
            return format(int(float(value)), '016b')
        if isinstance(value, str):
            return format(int(value, 16), '016b')
        return format(int(value), '016b')
    except Exception:
        return 'x' * 16  # Use unknowns if conversion fails

def generate_stil_from_csv(csv_file, output_stil):
    # Load CSV file
    df = pd.read_csv(csv_file)

    # Start writing STIL content
    stil_lines = []
    stil_lines.append("STIL 1.0;\n")
    stil_lines.append("Signals {\n")
    stil_lines.append('    "clk" In;\n')
    stil_lines.append('    "data_in[15:0]" In;\n')
    stil_lines.append('    "fault_mask[15:0]" In;\n')
    stil_lines.append('    "fault_value[15:0]" In;\n')
    stil_lines.append('    "crc_out[15:0]" Out;\n')
    stil_lines.append("};\n\n")

    stil_lines.append("SignalGroups {\n")
    stil_lines.append('    "all_inputs" = "clk", "data_in[15:0]", "fault_mask[15:0]", "fault_value[15:0]";\n')
    stil_lines.append("};\n\n")

    stil_lines.append("Patterns {\n")

    for _, row in df.iterrows():
        time = int(row["Time_ns"])
        clk = "0"
        data_in_bin = hex_to_bin_fixed(row["Data_in"])
        fault_mask_bin = hex_to_bin_fixed(row["FaultMask"])
        fault_value_bin = hex_to_bin_fixed(row["FaultValue"])
        crc_out_bin = hex_to_bin_fixed(row["CRC_out"])

        input_vector = clk + data_in_bin + fault_mask_bin + fault_value_bin
        output_vector = crc_out_bin

        stil_lines.append(f'    Vectors {{ "{input_vector}" "{output_vector}"; }} // Time: {time}ns\n')

    stil_lines.append("};\n")

    with open(output_stil, "w") as f:
        f.writelines(stil_lines)

    print(f"STIL file saved to: {output_stil}")


# Example usage
if __name__ == "__main__":
    csv_input_path = "crc_fault_sweep.csv"
    stil_output_path = "crc_fault_sweep.stil"
    generate_stil_from_csv(csv_input_path, stil_output_path)
