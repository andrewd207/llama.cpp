#ifdef MUL_MAT_ID
shared u16vec2 row_ids[BN];
uint _ne1;

// Rows of this tile from the list compacted by count_experts (n_as = gl_NumWorkGroups.z)
void load_row_ids(uint expert_idx, uint ic) {
    _ne1 = data_expert_count[expert_idx];
    const uint base = 2 * gl_NumWorkGroups.z + data_expert_count[gl_NumWorkGroups.z + expert_idx] + ic * BN;
    for (uint c = gl_LocalInvocationIndex; c < BN; c += gl_WorkGroupSize.x) {
        const uint e = ic * BN + c < _ne1 ? data_expert_count[base + c] : 0;
        row_ids[c] = u16vec2(e & 0xFFFF, e >> 16);
    }
    barrier();
}
#endif // MUL_MAT_ID
