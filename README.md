# Rumo à Procedência - Professional Landing Page

This project provides a professional infrastructure for hosting static websites on AWS, with automated deployment, manual approval, and alerting. The workflow is secure, auditable, and production-ready.

## Features
- **Static hosting** on S3 with versioning, lifecycle, and secure public policy.
- **Automated deploy** via GitHub Actions (GHA) using OIDC (no static secrets).
- **Manual approval** for production deploy.
- **Staging deploy** via GitHub Pages.
- **Email alerts** via configurable SNS.
- **Notifications and outputs**: Site URLs (S3 and GitHub Pages) shown in the GitHub Actions summary.
- **Images and files** can be uploaded manually to S3 without being overwritten by deploys.
- **Two deployment workflows**: Waiting list and offer landing pages.

## Project Structure
```
├── index.html                    # Main offer landing page
├── index-lista.html             # Waiting list landing page
├── 404.html                     # Error page
├── terraform/                   # Infrastructure as code
├── .github/workflows/
│   ├── gh-pages.yml             # Offer landing page deploy (GHA)
│   ├── lista-espera.yml         # Waiting list deploy (GHA)
│   └── tf-config.yml            # Infrastructure pipeline (GHA)
```

## How Deploy Works

### 1. Infrastructure Deploy (Terraform)
- Pipeline: `.github/workflows/tf-config.yml`
- Runs on push/pull request to `main` branch.
- Provisions/updates AWS resources via Terraform.
- Important outputs (like S3 site URL) appear in the GitHub Actions summary.

**How to run manually:**
- Edit files in `terraform/` and push to `main`.
- Or run locally:
  ```sh
  cd terraform
  terraform init
  terraform apply
  ```

### 2. Site Deploy - Two Options

#### A) Waiting List Deploy (`lista-espera.yml`)
- **Use when**: You want to deploy a waiting list page
- **Pipeline**: `.github/workflows/lista-espera.yml`
- **File**: Deploys `index-lista.html` (waiting list version)
- **Inputs**: 
  - `PAYMENT_URL`: URL for payment form (Google Forms, Hotmart, etc.)
- **Steps:**
  1. Deploy to GitHub Pages (staging/dev)
  2. Manual approval (environment `production`)
  3. Deploy to S3 (production)

**How to run:**
- Go to _Actions_ > _Deploy Lista de espera_ > _Run workflow_
- Fill in the `PAYMENT_URL` field
- Wait for manual approval to publish to production

#### B) Offer Landing Page Deploy (`gh-pages.yml`)
- **Use when**: You want to deploy a full offer/sales page
- **Pipeline**: `.github/workflows/gh-pages.yml`
- **File**: Deploys `index.html` (main offer page)
- **Inputs**: Multiple fields for pricing, offers, dates, etc.
- **Steps:**
  1. Deploy to GitHub Pages (staging/dev)
  2. Manual approval (environment `production`)
  3. Deploy to S3 (production)

**How to run:**
- Go to _Actions_ > _Deploy Landing Page_ > _Run workflow_
- Fill in all the required fields (pricing, offers, dates, etc.)
- Wait for manual approval to publish to production

## Important Variables
- Set Terraform variables as repository variables in GitHub:
  - `TF_VAR_bucket_name` (S3 bucket name)
  - `TF_VAR_sns_email` (alert email)
  - `TF_VAR_region` (AWS region, e.g. sa-east-1)
  - `CUSTOM_DOMAIN` (Cloudflare custom domain)
  - `DOMAIN` (Cloudflare domain)
- Secrets: `AWS_ACCOUNT_ID` (for OIDC assume role)

## Manual Upload of Files (images, etc)
- For files that should not be overwritten by deploys, upload them manually to a folder excluded from sync (e.g. `images/`).
- Use AWS CLI:
  ```sh
  aws s3 cp path/to/image.jpg s3://<bucket>/images/image.jpg --content-type image/jpeg
  ```
- Reference in HTML using the public S3 URL.

## Security
- Production deploy only after manual approval.
- Automated deploy via OIDC (no static secrets).
- S3 bucket is public only via policy, no ACLs.
- Sensitive variables are never versioned.

## Notes
- The public S3 site endpoint is: `http://<bucket>.s3-website-<region>.amazonaws.com`
- Deploy does not overwrite files in excluded folders (e.g. `images/`).
- The project is easily adaptable for custom domains and Cloudflare via Terraform.
- **Waiting list page** (`index-lista.html`) is simpler and only requires a payment URL.
- **Offer page** (`index.html`) is more complex and requires multiple pricing/offer inputs.

---

## Quick Reference

| When to Use | Workflow | File | Inputs |
|-------------|----------|------|--------|
| **Waiting List** | Deploy Lista de espera | `index-lista.html` | Payment URL only |
| **Full Offer** | Deploy Landing Page | `index.html` | Multiple pricing/offer fields |

**Example URLs:**
- Waiting List: `https://rumoaprocedenica.com/index-lista.html`
- Main Offer: `https://rumoaprocedenica.com/`
