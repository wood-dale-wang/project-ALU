def generate_and_statements(max_index=30,Gnum=0,Pstart=1):
    """
    Generate Verilog 'and' statements for PxG0[0] to PxG0[max_index]
    This corresponds to i from 1 to max_index+1
    """
    lines = [f"  wire PxG{Gnum}[{max_index}:0];"]
    for idx in range(0, max_index + 1):  # idx = 0 to 30
        i = idx + 1  # because p1g0 corresponds to PxG0[0]
        output = f"PxG{Gnum}[{idx}]"
        # Build P inputs: P[i], P[i-1], ..., P[1]
        p_inputs = [f"P[{j+Pstart-1}]" for j in range(i, 0, -1)]  # from i down to 1
        inputs = [output] + p_inputs + [f"G[{Gnum}]"]
        input_str = ",".join(inputs)
        instance_name = f"u_and_p{i+Pstart-1}g{Gnum}"
        line = f"  and {instance_name}({input_str});"
        lines.append(line)
    return "\n".join(lines)

def gPxGx():
    """
    PxG0~PxG30
    """
    # Generate for PxG0[0] to PxG0[30]
    with open("out.txt","w") as file:
        for i in range(0,31):
            print(generate_and_statements(max_index=30-i,Gnum=i,Pstart=i+1),file=file,flush=True)

def generate_or_statements(max_n=30):
    """
    Generate Verilog 'or' statements for C[0] to C[max_n]
    
    Format:
      or u_or_c0(C[0],G[0],PxCIN[0]);
      or u_or_c1(C[1],G[1],PxG0[0],PxCIN[1]);
      or u_or_c2(C[2],G[2],PxG1[0],PxG0[1],PxCIN[2]);
      ...
    """
    lines = []
    for n in range(0, max_n + 1):
        # Start building the port list
        ports = [f"C[{n}]", f"G[{n}]"]
        
        # Add PxG terms: for k in 0 to n-1 → PxG{n-1-k}[k]
        pxg_terms = []
        for k in range(0, n):
            g_index = n - 1 - k   # e.g., for n=3, k=0 → g=2; k=1 → g=1; k=2 → g=0
            array_index = k
            pxg_terms.append(f"PxG{g_index}[{array_index}]")
        
        ports.extend(pxg_terms)
        ports.append(f"PxCIN[{n}]")
        
        port_str = ",".join(ports)
        line = f"  or u_or_c{n}({port_str});"
        lines.append(line)
    
    return "\n".join(lines)

def generate_ress():
    lines = []
    for i in range(0,32):
        if i==0:
            line=f"xor u_xor_r{i}(res[{i}],a[{i}],b[{i}],cin);"
        else:
            line=f"xor u_xor_r{i}(res[{i}],a[{i}],b[{i}],C[{i-1}]);"
        lines.append(line)
    return "\n".join(lines)

if __name__=="__main__":
    # print(generate_or_statements(31))
    print(generate_ress())