
page 51441 "Tender Plan Card"
{
    Caption = 'Tender Card';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Tender Plan Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Tender Description"; Rec."Tender Description")
                {
                    ToolTip = 'Specifies the value of the Tender Description field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Workplan Code"; Rec."Workplan Code")
                {
                    Caption = 'Activity Code';
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }
                field("Workplan Description"; Rec."Workplan Description")
                {
                    Caption = 'Activity Description';
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ToolTip = 'Specifies the value of the Procurement Method field.';
                }
                field("Procurement Method Name"; Rec."Procurement Method Name")
                {
                    ToolTip = 'Specifies the value of the Procurement Method Name field.';
                }
                field("Tender Category"; Rec."Tender Category")
                {
                    ToolTip = 'Specifies the value of the Tender Category field.';

                }
                field("Publishing Date"; Rec."Publishing Date")
                {
                    ToolTip = 'Specifies the value of the Publishing Date field.';
                }
                field("Publishing Time"; Rec."Publishing Time")
                {
                    ToolTip = 'Specifies the value of the Publishing Time field.';
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
                field("Closing Time"; Rec."Closing Time")
                {
                    ToolTip = 'Specifies the value of the Closing Time field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Tender Status';
                    ToolTip = 'Specifies the value of the Tender Status field.';
                }
                field(Addendum; Rec.Addendum)
                {
                    ToolTip = 'Specifies the value of the Addendum field.';
                }
            }
            part("Tender Subpage"; "Tender Subpage")
            {
                SubPageLink = "Tender No." = FIELD("No.");
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134838),
                              "No." = FIELD("No.");
            }
            part(MyPart; "Acc. Sched. KPI Web Srv. Lines")
            {
                ApplicationArea = All;
                SubPageView = SORTING("Acc. Schedule Name");
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }

            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Publish Tender")
            {
                Image = LaunchWeb;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Publish/Advertise Tender';
                ToolTip = 'Executes the Publish/Advertise Tender action.';

                trigger OnAction()
                var
                    Qvend: Record "Quotation Request Vendors";
                    UserSetup: Record "User Setup";
                    Tenders: Record "Tender Plan Header";

                begin
                    //IF Status <> Status::Published THEN ERROR('Please note that this tender has already been published or closed');
                    Rec.TESTFIELD("Closing Date");
                    Rec.TESTFIELD("Closing Time");
                    Rec.TESTFIELD("Procurement Method");
                    Procumethod.Reset();
                    Procumethod.SetRange(Code, Rec."Procurement Method");
                    if Procumethod.Find('-') then
                        IF Procumethod.Type = Procumethod.Type::Restricted THEN BEGIN
                            Qvend.RESET;
                            Qvend.SETRANGE("Requisition Document No.", Rec."No.");
                            IF NOT Qvend.FIND('-') THEN ERROR('Please add atleast one vendor for restricted tendering');
                        END;
                    IF Rec."Approval Status" <> Rec."Approval Status"::Approved THEN ERROR('Please note that this tender must be fully approved');
                    UserSetup.GET(USERID);
                    IF UserSetup."Can Publish Tender" = FALSE THEN ERROR('You do not have the permission to perform this action');

                    Tenders.GET(Rec."No.");
                    IF Tenders.HASLINKS = FALSE THEN ERROR('Please attach the Tender Document');

                    Rec."Publishing Date" := TODAY;
                    Rec."Publishing Time" := TIME;
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                    MESSAGE('Tender No. ' + Rec."No." + ' has been published');
                end;
            }
            action("Tender Bids")
            {
                Image = BarChart;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = Edit;
                ToolTip = 'Executes the Tender Bids action.';

                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                    passwordpage: Page "Tender Passwords Page";
                begin
                    IF Rec."Closing Date" <> TODAY THEN ERROR('Bids for this Tender can only be opened on ' + FORMAT(Rec."Closing Date"));
                    //IF "Closing Time" < TIME THEN ERROR('Bids for this Tender can only be opened at '+FORMAT("Closing Time"));
                    TenderCommittee.RESET;
                    TenderCommittee.SETFILTER("Tendor No", Rec."No.");
                    IF TenderCommittee.FIND('-') THEN BEGIN
                        Clear(passwordpage);
                        passwordpage.SetTableView(TenderCommittee);
                        passwordpage.SetRecord(TenderCommittee);
                        if passwordpage.RunModal() = Action::Cancel then
                            passwordpage.GetRecord(TenderCommittee);
                        //PAGE.RunModal()(Page::"Tender Passwords Page", TenderCommittee);
                    END ELSE BEGIN
                        ERROR('The opening committee for this Tender have not been set')
                    END;
                end;
            }
            action("Tender Commitee")
            {
                Caption = 'Commitee';
                Image = Group;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Tender Committee";
                RunPageLink = "Tendor No" = field("No.");
                ToolTip = 'Executes the Commitee action.';

            }
            action("Opening Commitee")
            {
                Caption = 'Opening Commitee';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Opening Commitee action.';

                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                begin
                    TenderCommittee.RESET;
                    TenderCommittee.SETFILTER("Tendor No", Rec."No.");
                    TenderCommittee.SETFILTER("Committee Type", 'Tender Opening Committee');
                    IF TenderCommittee.FIND('-') THEN BEGIN
                        PAGE.RUN(Page::"Tender Committee", TenderCommittee)
                    END ELSE BEGIN
                        ERROR('The opening committee for this Tender have not been set')
                    END;
                end;
            }
            action("Evaluation Commitee")
            {
                Caption = 'Evaluation Commitee';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Evaluation Commitee action.';
                //RunObject = Page 70135264;
                //RunPageLink = "Tendor No"=FIELD("No.");

                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Closed);
                    TenderCommittee.RESET;
                    TenderCommittee.SETFILTER("Tendor No", Rec."No.");
                    TenderCommittee.SETFILTER("Committee Type", 'Evaluation Committee');
                    IF TenderCommittee.FIND('-') THEN BEGIN
                        PAGE.RUN(Page::"Tender Committee", TenderCommittee)
                    END;
                end;
            }
            action("Send A&pproval Request")
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    ApprovalsMgmt: codeunit "Custom Approvals Codeunit";
                begin
                    IF NOT Rec.HASLINKS THEN
                        ERROR('Please attach documents on the links page');

                    VarVariant := Rec;
                    IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin

                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                end;
            }
            action("Cancel Approval Re&quest")
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                begin

                    VarVariant := Rec;
                    ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            action("Assign Vendor(s)")
            {
                Caption = 'Assign Vendor(s)';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Assign Vendor(s) action.';

                trigger OnAction()
                var
                    Vends: Record "Quotation Request Vendors";
                begin
                    Procumethod.Reset();
                    Procumethod.SetRange(Code, Rec."Procurement Method");
                    if Procumethod.Find('-') then
                        IF Procumethod.Type <> Procumethod.Type::Restricted THEN ERROR('This page is only for restricted tenders');
                    //IF "Procurement Method" <> 'RESRICTED TENDERING' THEN ERROR('This page is only for restricted tenders');
                    //CurrPage.CLOSE;
                    /*TESTFIELD(Status, Status::Released);
                    RFQVendProd.RESET;
                    RFQVendProd.SETRANGE("RFQ No", "No.");
                    IF NOT RFQVendProd.FIND('-') THEN BEGIN
                      ERROR('Please add atleast one vendor product category');
                      END;
                    
                    //delete all other allocated vendors
                    Vends.RESET;
                    Vends.SETRANGE("Requisition Document No.", "No.");
                    IF Vends.FIND('-') THEN BEGIN
                      WHILE Vends.FIND('-') DO
                      Vends.DELETE;
                      //Vends.DELETEALL;
                      END;
                    Window.OPEN('Assigning Vendors. Please Wait');
                    RFQVendProd.RESET;
                    RFQVendProd.SETRANGE("RFQ No", "No.");
                    IF RFQVendProd.FIND('-') THEN BEGIN
                      REPEAT
                      k:=RFQVendProd."No of Vendors"+1;
                      VendCats.RESET;
                      VendCats.SETRANGE(Categories, RFQVendProd."Product Categories");
                      //if special group is checked, restrict to special groups
                      IF "Special Group?" = TRUE THEN BEGIN
                      VendCats.SETFILTER("Special Group", '<>%1', VendCats."Special Group"::None);
                      VendCats.SETFILTER("Special Group", '<>%1', VendCats."Special Group"::" ");
                      END;
                      VendCats.SETCURRENTKEY("Last RFQ Assign Date");
                      VendCats.SETASCENDING("Last RFQ Assign Date", FALSE);
                      IF VendCats.FIND('-') THEN BEGIN
                        //FOR k:=1 TO RFQVendProd."No of Vendors" DO BEGIN
                        REPEAT
                          Vends.RESET;
                          Vends.SETRANGE("Requisition Document No.", "No.");
                          Vends.SETRANGE("Vendor No.", VendCats."Vendor No");
                          IF NOT Vends.FIND('-') THEN BEGIN
                            Vends.INIT;
                            Vends."Document Type":=Vends."Document Type"::"Quotation Request";
                            Vends."Requisition Document No.":="No.";
                            Vends."Vendor No.":=VendCats."Vendor No";
                            Vends."Date Assigned":=TODAY;
                            Vends.INSERT();
                            VendCats."Last RFQ Assign Date":=TODAY;
                            VendCats.MODIFY;
                          END;
                          k:=k-1;
                         UNTIL VendCats.NEXT=k;
                         //END;
                        END;
                      UNTIL RFQVendProd.NEXT=0;
                      END;
                      Window.CLOSE;
                      */
                    Vends.RESET;
                    Vends.SETRANGE(Vends."Document Type", Vends."Document Type"::"Restricted Tender");
                    Vends.SETRANGE(Vends."Requisition Document No.", Rec."No.");

                    PAGE.RUNMODAL(PAGE::"Quotation Request Vendors", Vends);

                end;
            }
            action("Publish Addendum")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Publish Addendum action.';

                trigger OnAction()
                var
                    Qvend: Record "Quotation Request Vendors";
                    UserSetup: Record "User Setup";
                    Tenders: Record "Tender Plan Header";
                begin
                    //IF Status <> Status::Published THEN ERROR('Please note that this tender has already been published or closed');
                    Rec.TESTFIELD(Addendum, TRUE);
                    Rec.TESTFIELD("Closing Date");
                    Rec.TESTFIELD("Closing Time");
                    Rec.TESTFIELD("Procurement Method");
                    IF Rec."Procurement Method" = rec."Procurement Method"::"Restricted Tender" THEN BEGIN
                        Qvend.RESET;
                        Qvend.SETRANGE("Requisition Document No.", Rec."No.");
                        IF NOT Qvend.FIND('-') THEN ERROR('Please add atleast one vendor for restricted tendering');
                    END;
                    IF Rec."Approval Status" <> Rec."Approval Status"::Approved THEN ERROR('Please note that this tender must be fully approved');
                    UserSetup.GET(USERID);
                    IF UserSetup."Can Publish Tender" = FALSE THEN ERROR('You do not have the permission to perform this action');

                    Tenders.GET(Rec."No.");
                    IF Tenders.HASLINKS = FALSE THEN ERROR('Please attach the Tender Document');

                    Rec."Publishing Date" := TODAY;
                    Rec."Publishing Time" := TIME;
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                    MESSAGE('Tender No. ' + Rec."No." + ' has been published');
                end;
            }
        }
    }
    var
        Procumethod: Record "Procurement Methods";
}

