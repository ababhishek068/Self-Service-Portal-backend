#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51512 "Orientation List-Approval"
{
    Caption = 'Staff Orientation Checklists Awaiting Approval';
    CardPageID = "Orientation Header-Approval";
    PageType = List;
    SourceTable = "Staff Orientation Header";
    SourceTableView = where(Status=const("Pending Approval"));

    layout
    {
        area(content)
        {
            repeater("Staff Information")
            {
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 3 Code";"Global Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Manager;Manager)
                {
                    ApplicationArea = Basic;
                }
                field("Manager's Name";"Manager's Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile No";"Mobile No")
                {
                    ApplicationArea = Basic;
                }
                field("Employment Date";"Employment Date")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control15;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

