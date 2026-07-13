namespace microsoft;
using Microsoft.EServices.EDocument;
using Microsoft.Finance.AllocationAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Deferral;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.VAT.Setup;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Insurance;
using Microsoft.FixedAssets.Maintenance;
using Microsoft.FixedAssets.Posting;
using Microsoft.FixedAssets.Setup;
using Microsoft.Foundation.Attachment;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Calendar;
using Microsoft.Foundation.Enums;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Foundation.UOM;
using Microsoft.Intercompany.GLAccount;
using Microsoft.Intercompany.Partner;
using Microsoft.Inventory;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Intrastat;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Pricing.Calculation;
using Microsoft.Pricing.PriceList;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Journal;
using Microsoft.Projects.Project.Planning;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.Comment;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Pricing;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Request;
using Microsoft.Warehouse.Setup;
using Microsoft.Warehouse.Structure;
using System.Utilities;
using System.Environment.Configuration;

page 51485 IndividualizedBudgetLine
{
    ApplicationArea = All;
    Caption = 'IndividualizedBudgetLine';
    PageType = ListPart;
    SourceTable = "Budget line";
    //AutoSplitKey = true;    
    DelayedInsert = true;
    LinksAllowed = false;
   // MultipleNewLines = true;    
        
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Budget No"; Rec."Budget No")
                {
                    ToolTip = 'Specifies the value of the Budget No field.', Comment = '%';
                    Visible=false;
                }
                field("Budget year"; Rec."Budget year")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Budget year field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Gl Account"; Rec."Gl Account")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Gl Account field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(UoM; Rec.UoM)
                {
                    ToolTip = 'Specifies the value of the UoM field.', Comment = '%';
                }
                field("Current Quantity"; Rec."Current Quantity")
                {
                    ToolTip = 'Specifies the value of the Current Quantity field.', Comment = '%';
                }
                field(Functional; Rec.Functional)
                {
                    ToolTip = 'Specifies the value of the Functional field.', Comment = '%';
                }
                field("Partially Functional"; Rec."Partially Functional")
                {
                    ToolTip = 'Specifies the value of the Partially Functional field.', Comment = '%';
                }
                field("Non Functional";"Non Functional"){}
                field(Justification; Rec.Justification)
                {
                    ToolTip = 'Specifies the value of the Justification field.', Comment = '%';
                }
                field(N; Rec.N)
                {
                    ToolTip = 'Specifies the value of the N field.', Comment = '%';
                }
                field("N(Birr)"; Rec."N(Birr)")
                {
                    ToolTip = 'Specifies the value of the N(Birr) field.', Comment = '%';
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field(R; Rec.R)
                {
                    ToolTip = 'Specifies the value of the R field.', Comment = '%';
                }
                field("R(Birr)"; Rec."R(Birr)")
                {
                    ToolTip = 'Specifies the value of the R(Birr) field.', Comment = '%';
                }
                field(T; Rec.T)
                {
                    ToolTip = 'Specifies the value of the T field.', Comment = '%';
                }
                field("T(Birr)"; Rec."T(Birr)")
                {
                    ToolTip = 'Specifies the value of the T(Birr) field.', Comment = '%';
                }
                field("Estimated Cost"; Rec."Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Estimated Cost field.', Comment = '%';
                }
            }
        }
    }
}
