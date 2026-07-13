report 50013 "copy PV"
{
    ApplicationArea = All;
    Caption = 'copy PV';
    UsageCategory = Tasks;
    dataset
    {
        dataitem(PaymentsHeader; "Payments Header")
        {
            column(No; "No.") { }
            trigger OnAfterGetRecord()
            begin
                PaymentsH.Reset();
                PaymentsH.SetRange(PaymentsH."No.", OldPVNo);
                if PaymentsH.Find('-') then begin

                    //PaymentsH."Shortcut Dimension 2 Code" := oldDimension;

                end;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                    field(OldPVNo; OldPVNo)
                    {
                        ApplicationArea = basic;
                        ToolTip = 'Specifies the value of the OldPVNo field.';
                    }
                }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
    var
        PaymentsH: Record "Payments Header";
        OldPVNo: Code[20];

}
