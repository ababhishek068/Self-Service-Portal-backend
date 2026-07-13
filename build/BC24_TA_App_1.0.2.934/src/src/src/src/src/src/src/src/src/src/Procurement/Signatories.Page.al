#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51510 Signatories
{
    CardPageID = "Signatory Card";
    PageType = List;
    SourceTable = Signatories;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("1st Signatory";"1st Signatory")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Signatory";"2nd Signatory")
                {
                    ApplicationArea = Basic;
                }
                field("3rd Signatory";"3rd Signatory")
                {
                    ApplicationArea = Basic;
                }
                field(Stamp;Stamp)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
    }
}

