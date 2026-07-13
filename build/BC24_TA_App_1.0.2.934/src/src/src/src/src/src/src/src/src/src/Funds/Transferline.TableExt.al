tableextension 50039 Transferline extends "Transfer Line"
{
    fields
    {
        field(50000; "External Location"; boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."External Location" where(Code = field("Transfer-to Code")));
        }
        field(50001; "External Posted"; boolean) { }
    }
}