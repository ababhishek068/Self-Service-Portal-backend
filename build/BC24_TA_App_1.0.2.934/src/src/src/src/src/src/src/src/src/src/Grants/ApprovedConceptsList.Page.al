Page 51173 "Approved Concepts List"
{
    //CardPageID = "Approved Concepts";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = where(Status = const("Concept Formulation"),
                            "Approval Status" = filter(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Search Description field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field(BilltoPartnerNo; Rec."Bill-to Partner No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.';
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PersonResponsible; Rec."Person Responsible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Person Responsible field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(CustomerDiscGroup; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Disc. Group field.';
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Price Group field.';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Language Code field.';
                }
                field(ScheduledResQty; Rec."Scheduled Res. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Res. Qty. field.';
                }
                field(ResourceFilter; Rec."Resource Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resource Filter field.';
                }
                field(PostingDateFilter; Rec."Posting Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date Filter field.';
                }
                field(ResourceGrFilter; Rec."Resource Gr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resource Gr. Filter field.';
                }
                field(ScheduledResGrQty; Rec."Scheduled Res. Gr. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Res. Gr. Qty. field.';
                }
            }
        }
    }

    actions { }
}

