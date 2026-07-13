tableextension 50048 Vendorext extends Vendor
{
    fields
    {

        field(50000; "TIN No"; code[40])
        {
            Caption = 'TIN No';
            ToolTip = 'Input Vendor TIN No';
        }
        field(50001;"Blacklisted?";Boolean){

        }
        field(50002;"Blaclisting Start Date";Date){
            trigger OnValidate()
            begin
                // if "Blacklisting Period"<>0 then begin
                //     Validate("Blaclisting Start Date");
                // end;
            end;
        }

        field(50003;"Blaclisting End Date";Date){
            Editable=false;
        }

        field(50004;"Blacklisting Period";DateFormula){
            trigger OnValidate()
            begin
                TestField("Blaclisting Start Date");
                "Blaclisting End Date" := CALCDATE("Blacklisting Period", "Blaclisting Start Date");
                if "Blaclisting End Date"<>0D then
                "Blacklisted?":=true;
            end;
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
