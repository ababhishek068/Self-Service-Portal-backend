#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51505 "Commitee Members"
{
    PageType = ListPart;
    SourceTable = "Commitee Members";

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Chair;Chair)
                {
                    ApplicationArea = Basic;
                }
                field(Secretary;Secretary)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

