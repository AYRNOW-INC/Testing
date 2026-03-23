# AYRNOW Build Rules

Hard rules for all future implementation work. No exceptions.

---

## UI Truth Hierarchy
1. **PNG wireframes** (`/AYRNOW/wireframe/`) are the PRIMARY and AUTHORITATIVE reference for all screen layouts, flows, components, spacing, and functionality.
2. **React example screens folder** is the SECONDARY reference for visual behavior, icons, spacing, assets, and component structure. **Status: NOT FOUND in current workspace.** If added later, use as secondary reference.
3. **AYRNOW docs** (`CLAUDE.md`, `knowledge.md`, `.docx` files) define business rules, data models, and scope boundaries.
4. **Existing generated code** is the LOWEST priority. Override it whenever it conflicts with wireframes.

## Strict Prohibitions
- **NO invented screen layouts.** Every screen must trace back to a specific wireframe PNG.
- **NO generic placeholder UI.** No "coming soon" cards, no lorem ipsum, no stub screens.
- **NO redesigning screens from scratch.** Follow wireframe layout exactly.
- **NO bottom sheets where wireframes show full-screen routes.** Only use bottom sheets if the wireframe explicitly shows one.
- **NO single-page forms where wireframes show multi-step wizards.**
- **NO SegmentedButton or DropdownButton where wireframes show selectable cards or icon buttons.**
- **NO simple ListTiles where wireframes show rich cards with images, avatars, badges, and action buttons.**

## Required Stack (Non-Negotiable)
- **Frontend:** Flutter only
- **Backend:** Java Spring Boot only
- **Database:** PostgreSQL only
- **Migrations:** Flyway only
- **Architecture:** Monolith only
- **Docker:** NONE — not allowed anywhere

## Screen Implementation Requirements
Every screen must implement:
1. **Loading state** — spinner or shimmer while data fetches
2. **Empty state** — per wireframe (illustration + CTA, not just text)
3. **Populated state** — per wireframe layout exactly
4. **Error state** — meaningful message + retry option
5. **All components shown in the wireframe** — every button, card, badge, icon, field, link

## Component Fidelity Rules
- Use the same **icon types** shown in wireframes (outline vs filled, same meaning)
- Use the same **color scheme**: primary blue (#1565C0 or similar), success green, error red, warning orange
- Use the same **card structure**: rounded corners, shadows, padding matching wireframes
- Use the same **typography hierarchy**: large bold headings, medium subheadings, regular body text
- Use the same **button styles**: full-width blue filled for primary, outlined for secondary, text for tertiary
- Stat cards must show **the same metrics** as wireframes (not invented alternatives)
- Status badges must use **the same colors and text** as wireframes

## Navigation Rules
- Landlord bottom nav: **Dashboard | Properties | Leases | Payments | Account** (5 tabs)
- Tenant bottom nav: **Home | Lease | Pay | Docs | Account** (5 tabs)
- Each tab corresponds to specific wireframe screens
- Secondary screens (detail views, wizards, settings) push as full-screen routes with back arrows
- Notifications accessed via bell icon in app bar, opens dedicated screen

## Backend Integration Rules
- Frontend calls only `/api/*` endpoints on the Spring Boot backend
- All auth uses JWT Bearer tokens
- File uploads use multipart form data
- Payment flow uses Stripe Checkout (redirect-based for MVP)
- Final payment state comes from backend webhooks, not client-side
- Role-based access enforced on both frontend (route guards) and backend (@PreAuthorize)

## Testing Requirements Before Handoff
Per CLAUDE.md Section 17, each vertical slice must include:
- Loading state verified
- Empty state verified
- Error state verified
- Success state verified
- Backend validation confirmed
- Correct HTTP codes
- Works on iOS simulator
