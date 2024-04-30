local function switch_line(idx)
    local cursor = vim.fn.getcurpos(0)
    local curr_line_content = vim.api.nvim_get_current_line()
    local curr_line_num = cursor[2]
    local rplc_line_num = curr_line_num + idx

    local line_exists = rplc_line_num >= 1 and vim.api.nvim_buf_line_count(0) >= rplc_line_num
    if not line_exists then return end

    vim.fn.cursor(cursor[2]+idx, cursor[1])
    local rplc_line_content = vim.api.nvim_get_current_line()

    vim.api.nvim_buf_set_lines(0, rplc_line_num-1, rplc_line_num, _, {curr_line_content})
    vim.api.nvim_buf_set_lines(0, curr_line_num-1, curr_line_num, _, {rplc_line_content})

end

return {
    switch_line = switch_line,
}
