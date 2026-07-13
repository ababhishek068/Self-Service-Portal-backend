tableextension 50027 SalesPerson extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Sales Account No"; code[20])
        {
            TableRelation = Customer."No." where("Customer Type" = filter("Pump Attendance"));
        }
        field(5001; "In Active Shift"; boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Shift Allocation Line" where("Staff No" = field(Code), "Station Code" = field("Global Dimension 1 Code"), Open = filter(true), Posted = filter(False)));
        }
        field(5003; "Active Shift No"; code[20]) { }
        field(5002; "Active"; boolean) { }
        field(5004; "Customer Pricing Code"; code[20])
        {
            TableRelation = "Customer Price Group".Code;
        }

    }
}