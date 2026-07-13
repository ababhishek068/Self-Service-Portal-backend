tableextension 50049 Compinfoexten extends "Company Information"
{
    fields
    {

        field(50000; "TIN No"; code[40])
        {
            Caption = 'TIN No';
            ToolTip = 'Input Company TIN No';
        }
        modify(Address)
        {
            Caption = 'Address City/Town';

        }
        modify("Post Code")
        {
            Caption = 'HNo';
        }
        modify("Address 2")
        {
            Caption = 'Sub-City';
        }
        modify(City)
        {
            Caption = 'Woreda';
        }
    }
}
