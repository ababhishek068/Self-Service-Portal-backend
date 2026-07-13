#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51508 "Minutes Setup"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Minutes Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Specify Month";"Specify Month")
                {
                    ApplicationArea = Basic;
                }
                field("Min Code";"Min Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quote Description";"Quote Description")
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

