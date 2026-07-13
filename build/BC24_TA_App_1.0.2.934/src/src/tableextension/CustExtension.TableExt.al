tableextension 50043 CustExtension extends Customer
{
    fields
    {

        field(50000; "TIN No"; code[40])
        {
            Caption = 'TIN No';
            ToolTip = 'Input Customer TIN No';
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
