Page 51001 "Registry Role Centre"
{
    Caption = 'Central Service Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control60; "Headline RC General Mgt.")
            {
                ApplicationArea = RelationshipMgmt;
            }

            group(Control18)
            {
                systempart(Control17; Outlook) { }
            }
            group(Control16)
            {
                part(Control15; "My Job Queue")
                {
                    Visible = false;
                }

                systempart(Control13; MyNotes) { }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Registry)
            {

                group(Inbound)
                {
                    Caption = 'Out-bound Mails';
                    // Image = Reconcile;
                    action(NewOutbound)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New (Outbound)';
                        RunObject = Page "New Outbound Mails List";
                        ToolTip = 'Executes the New (Outbound) action.';
                    }
                    action(Dispatch)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dispatch';
                        RunObject = Page "Outbound Mail (Dispartch) List";
                        ToolTip = 'Executes the Dispatch action.';
                    }
                    action(Released)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Released';
                        RunObject = Page "Released Outbound Mails List";
                        ToolTip = 'Executes the Released action.';
                    }
                }
                group(In_bound)
                {
                    Caption = 'In-bound Mails';
                    // Image = Capacities;
                    action(NewInboundMails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Inbound Mails';
                        RunObject = Page "New Inbound Mails List";
                        ToolTip = 'Executes the New Inbound Mails action.';
                    }
                    action(InboundSorting)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Inbound (Sorting)';
                        RunObject = Page "Inbound Mails (Sorting) List";
                        ToolTip = 'Executes the Inbound (Sorting) action.';
                    }
                    action(Sorted)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sorted';
                        RunObject = Page "Sorted Inbound Mails List";
                        ToolTip = 'Executes the Sorted action.';
                    }
                }
                group(File_Movement)
                {
                    Caption = 'File Movement';
                    // Image = ResourcePlanning;
                    action(NewRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'General Files';
                        RunObject = Page "Registry Files List";
                        ToolTip = 'Executes the General Files action.';
                    }
                    action(PersonelFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Personel Files';
                        RunObject = Page "Registry Personel Files List";
                        ToolTip = 'Executes the Personel Files action.';
                    }
                    action(ActiveRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Active Reg. Files';
                        RunObject = Page "Active Files List";
                        ToolTip = 'Executes the Active Reg. Files action.';
                    }
                    action(PartiallyActiveFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Partially Active Files';
                        RunObject = Page "Partially Active Files List";
                        ToolTip = 'Executes the Partially Active Files action.';
                    }
                    action(BringupRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bring-up Reg. Files';
                        RunObject = Page "Bringup Registry Files List";
                        ToolTip = 'Executes the Bring-up Reg. Files action.';
                    }
                    action(DispatchRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dispatched Reg. Files';
                        RunObject = Page "Dispatched Registry Files List";
                        ToolTip = 'Executes the Dispatched Reg. Files action.';
                    }
                    action(DisposedRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Disposed Reg. Files';
                        RunObject = Page "Disposed Registry Files List";
                        ToolTip = 'Executes the Disposed Reg. Files action.';
                    }
                    action(ArchivedRegFiles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archived Reg. Files';
                        RunObject = Page "Archived Registry Files List";
                        ToolTip = 'Executes the Archived Reg. Files action.';
                    }
                }
                group(MailReports)
                {
                    Caption = 'Reports';
                    action(MailRegister)
                    {
                        ApplicationArea = basic;
                        Caption = 'Mail Register Report';
                        RunObject = report "Mail Register Report";
                        ToolTip = 'Executes the Mail Register Report action.';
                    }

                }

            }
            group(Estate)
            {
                Caption = 'Estate';
                // Image = ExportShipment;
                action(Waterbill)
                {
                    ApplicationArea = basic;
                    Caption = 'Water Bill';
                    RunObject = page "Water Bill Register";
                    ToolTip = 'Executes the Water Bill action.';
                }
                action(Electbill)
                {
                    ApplicationArea = basic;
                    Caption = 'Electricity Bill';
                    RunObject = page "Electricity Bill Register";
                    ToolTip = 'Executes the Electricity Bill action.';
                }
                action(sInvoice)
                {
                    ApplicationArea = basic;
                    Caption = 'Sales Invoicing';
                    RunObject = page "Sales Invoice List";
                    ToolTip = 'Executes the Sales Invoicing action.';
                }

            }
            group(Maintainance)
            {
                Caption = 'Maintainance';
                // Image = ExportShipment;
                action(EquipmentCalibration)
                {
                    ApplicationArea = basic;
                    Caption = 'Equipment Calibration Register';
                    RunObject = page "Equipment Calibration";
                    ToolTip = 'Executes the Equipment Calibration Register action.';
                }
                action(ChemReq)
                {
                    ApplicationArea = basic;
                    Caption = 'Chemicals Requisition and Usage Register';
                    RunObject = page "Chemical Usage Register";
                    ToolTip = 'Executes the Chemicals Requisition and Usage Register action.';
                }
                action(MatrialUsage)
                {
                    ApplicationArea = basic;
                    Caption = 'Material Usage Register';
                    RunObject = page "Material Usage Register";
                    ToolTip = 'Executes the Material Usage Register action.';
                }
                action(PlantMaint)
                {
                    ApplicationArea = basic;
                    Caption = 'Plant and Equipment Maintainance Register';
                    RunObject = page "Equipment Maintainance";
                    ToolTip = 'Executes the Plant and Equipment Maintainance Register action.';
                }
                action(WaterProd)
                {
                    ApplicationArea = basic;
                    Caption = 'Water Production Register';
                    RunObject = page "Water Production";
                    ToolTip = 'Executes the Water Production Register action.';
                }

            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    Caption = 'Stores Requisitions';
                    ApplicationArea = basic;
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action("Staff Claim")
                {
                    Caption = 'Staff Claim';
                    ApplicationArea = basic;
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action("Purchase Requisition")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = basic;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Imprest Surrender")
                {
                    Caption = 'Imprest Surrender';
                    ApplicationArea = basic;
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("Imprest Requisitions")
                {
                    Caption = 'Imprest Requisitions';
                    ApplicationArea = basic;
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(Action68)
                {
                    Caption = 'Leave Applications';
                    ApplicationArea = basic;
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("My Approved Leaves")
                {
                    Caption = 'My Approved Leaves';
                    ApplicationArea = basic;
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action("File Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "File Requisition List";
                    ToolTip = 'Executes the File Requisitions action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }
            group(Setup)
            {
                Caption = 'Setups';
                action(Setups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Set Ups';
                    RunObject = Page "Security Setups";
                    ToolTip = 'Executes the Set Ups action.';
                }
            }

        }
        area(Reporting)
        {
            group(RegistryReport)
            {
                Caption = 'Registry Reports';
                action(Outbound)
                {
                    ApplicationArea = Basic;
                    Caption = 'Outbound Mails';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Out-bound Mails";
                    ToolTip = 'Executes the Outbound Mails action.';
                }
                action(Inbound_Rep)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inbound Mails';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "In-bound Mails";
                    ToolTip = 'Executes the Inbound Mails action.';
                }
                action(Reg_Files)
                {
                    ApplicationArea = Basic;
                    Caption = 'Registry Files';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Registry Files";
                    ToolTip = 'Executes the Registry Files action.';
                }
            }

            group(MaintReports)
            {
                Caption = 'Maintainance Reports';
                action(EquipCalibReport)
                {
                    ApplicationArea = basic;
                    Caption = 'Equipment Calibration Report';
                    RunObject = report "Equipment Calibration Register";
                    ToolTip = 'Executes the Equipment Calibration Report action.';
                }
                action(EquipMaintbReport)
                {
                    ApplicationArea = basic;
                    Caption = 'Equipment Maintainance Report';
                    RunObject = report "Maintenance Register";
                    ToolTip = 'Executes the Equipment Maintainance Report action.';
                }
                action(MaterialUsage)
                {
                    ApplicationArea = basic;
                    Caption = 'Material Usage Report';
                    RunObject = report "Material Usage";
                    ToolTip = 'Executes the Material Usage Report action.';
                }
                action(ChemReqbReport)
                {
                    ApplicationArea = basic;
                    Caption = 'Chemical Requisition Report';
                    RunObject = report "Chemical Requisition";
                    ToolTip = 'Executes the Chemical Requisition Report action.';
                }
                action(EquipmentRegister)
                {
                    ApplicationArea = basic;
                    Caption = 'Tools & Equipment Register';
                    RunObject = report "Tools & Equipments Register";
                    ToolTip = 'Executes the Tools & Equipment Register action.';
                }
                action(WaterProdRep)
                {
                    ApplicationArea = basic;
                    Caption = 'Water Production Report';
                    RunObject = report "Water Production Register";
                    ToolTip = 'Executes the Water Production Report action.';
                }
            }
            group(EstateReports)
            {
                Caption = 'Estate Reports';
                action(WaterRegReport)
                {
                    ApplicationArea = basic;
                    Caption = 'Water Bill Register Report';
                    RunObject = report "Water Bills Register";
                    ToolTip = 'Executes the Water Bill Register Report action.';
                }
                action(SalesInRep)
                {
                    ApplicationArea = basic;
                    Caption = 'Invoice Report';
                    RunObject = report "Customer - Detail Trial Bal.";
                    ToolTip = 'Executes the Invoice Report action.';
                }
            }
        }

    }
}

