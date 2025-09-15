# LMS Frontend Redesign

This project provides a complete custom CSS redesign for the Learning Management System (LMS), replacing Bootstrap with a modern, accessible, and responsive design system.

## Files Overview

- `main.css` - Core design system with CSS variables, typography, spacing, and responsive grid
- `bootstrap-compat.css` - Compatibility layer that overrides Bootstrap classes
- `previews/` - HTML preview snippets for key LMS pages

## Integration Instructions

### Step 1: Remove Bootstrap

Remove all Bootstrap CDN links from your ASPX pages:

```html
<!-- Remove these lines -->
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
  rel="stylesheet"
/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
```

### Step 2: Include New Stylesheets

Add the new stylesheets to your MasterPage or individual pages:

```html
<!-- Add these lines -->
<link rel="stylesheet" href="~/main.css" />
<link rel="stylesheet" href="~/bootstrap-compat.css" />
```

### Step 3: Update File Paths

Ensure the CSS file paths are correct relative to your ASPX pages. If your CSS files are in the root directory, use:

```html
<link rel="stylesheet" href="main.css" />
<link rel="stylesheet" href="bootstrap-compat.css" />
```

### Step 4: Test and Validate

- Test all pages for visual consistency
- Verify responsive behavior on different screen sizes
- Check accessibility with screen readers and keyboard navigation
- Validate forms and interactive elements

## Design System Features

### CSS Variables

The design system uses CSS variables for easy customization:

```css
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --success-color: #28a745;
  --danger-color: #dc3545;
  --warning-color: #ffc107;
  --info-color: #17a2b8;
  --font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
  --spacer: 1rem;
  /* ... more variables */
}
```

### Responsive Grid

Mobile-first responsive grid system:

```html
<div class="container">
  <div class="row">
    <div class="col-md-6 col-lg-4">Column</div>
    <div class="col-md-6 col-lg-8">Column</div>
  </div>
</div>
```

### Component Classes

Modern component styling for buttons, forms, cards, and more:

```html
<button class="btn btn-primary">Primary Button</button>
<div class="card">
  <div class="card-body">
    <h5 class="card-title">Card Title</h5>
    <p class="card-text">Card content</p>
  </div>
</div>
```

## Bootstrap to New Style Mapping

### Buttons

| Bootstrap Class  | New Class        | Description        |
| ---------------- | ---------------- | ------------------ |
| `.btn`           | `.btn`           | Base button styles |
| `.btn-primary`   | `.btn-primary`   | Primary button     |
| `.btn-secondary` | `.btn-secondary` | Secondary button   |
| `.btn-success`   | `.btn-success`   | Success button     |
| `.btn-danger`    | `.btn-danger`    | Danger button      |
| `.btn-warning`   | `.btn-warning`   | Warning button     |
| `.btn-info`      | `.btn-info`      | Info button        |
| `.btn-light`     | `.btn-light`     | Light button       |
| `.btn-dark`      | `.btn-dark`      | Dark button        |
| `.btn-outline-*` | `.btn-outline-*` | Outlined buttons   |
| `.btn-lg`        | `.btn-lg`        | Large button       |
| `.btn-sm`        | `.btn-sm`        | Small button       |

### Forms

| Bootstrap Class     | New Class           | Description            |
| ------------------- | ------------------- | ---------------------- |
| `.form-control`     | `.form-control`     | Text input             |
| `.form-select`      | `.form-select`      | Select dropdown        |
| `.form-check`       | `.form-check`       | Checkbox/radio wrapper |
| `.form-check-input` | `.form-check-input` | Checkbox/radio input   |
| `.form-check-label` | `.form-check-label` | Checkbox/radio label   |
| `.form-group`       | `.mb-3`             | Form group spacing     |
| `.form-text`        | `.form-text`        | Form help text         |

### Layout

| Bootstrap Class      | New Class            | Description     |
| -------------------- | -------------------- | --------------- |
| `.container`         | `.container`         | Container       |
| `.row`               | `.row`               | Row             |
| `.col-*`             | `.col-*`             | Columns         |
| `.d-flex`            | `.d-flex`            | Flex display    |
| `.d-grid`            | `.d-grid`            | Grid display    |
| `.justify-content-*` | `.justify-content-*` | Justify content |
| `.align-items-*`     | `.align-items-*`     | Align items     |

### Cards

| Bootstrap Class | New Class      | Description    |
| --------------- | -------------- | -------------- |
| `.card`         | `.card`        | Card container |
| `.card-body`    | `.card-body`   | Card body      |
| `.card-header`  | `.card-header` | Card header    |
| `.card-footer`  | `.card-footer` | Card footer    |
| `.card-title`   | `.card-title`  | Card title     |
| `.card-text`    | `.card-text`   | Card text      |

### Navigation

| Bootstrap Class | New Class       | Description       |
| --------------- | --------------- | ----------------- |
| `.navbar`       | `.navbar`       | Navbar            |
| `.navbar-brand` | `.navbar-brand` | Navbar brand      |
| `.navbar-nav`   | `.navbar-nav`   | Navbar navigation |
| `.nav-link`     | `.nav-link`     | Navigation link   |
| `.navbar-dark`  | `.navbar-dark`  | Dark navbar       |
| `.navbar-light` | `.navbar-light` | Light navbar      |

### Tables

| Bootstrap Class  | New Class        | Description   |
| ---------------- | ---------------- | ------------- |
| `.table`         | `.table`         | Table         |
| `.table-striped` | `.table-striped` | Striped table |
| `.table-hover`   | `.table-hover`   | Hover table   |

### Utilities

| Bootstrap Class | New Class      | Description        |
| --------------- | -------------- | ------------------ |
| `.text-center`  | `.text-center` | Center text        |
| `.text-left`    | `.text-left`   | Left align text    |
| `.text-right`   | `.text-right`  | Right align text   |
| `.mb-*`         | `.mb-*`        | Margin bottom      |
| `.mt-*`         | `.mt-*`        | Margin top         |
| `.py-*`         | `.py-*`        | Padding vertical   |
| `.px-*`         | `.px-*`        | Padding horizontal |
| `.d-none`       | `.d-none`      | Display none       |
| `.w-100`        | `.w-100`       | Width 100%         |
| `.shadow`       | `.shadow`      | Shadow             |
| `.rounded`      | `.rounded`     | Border radius      |

### Alerts

| Bootstrap Class    | New Class          | Description     |
| ------------------ | ------------------ | --------------- |
| `.alert`           | `.alert`           | Alert           |
| `.alert-primary`   | `.alert-primary`   | Primary alert   |
| `.alert-secondary` | `.alert-secondary` | Secondary alert |
| `.alert-success`   | `.alert-success`   | Success alert   |
| `.alert-danger`    | `.alert-danger`    | Danger alert    |
| `.alert-warning`   | `.alert-warning`   | Warning alert   |
| `.alert-info`      | `.alert-info`      | Info alert      |

### Badges

| Bootstrap Class    | New Class          | Description     |
| ------------------ | ------------------ | --------------- |
| `.badge`           | `.badge`           | Badge           |
| `.badge-primary`   | `.badge-primary`   | Primary badge   |
| `.badge-secondary` | `.badge-secondary` | Secondary badge |
| `.badge-success`   | `.badge-success`   | Success badge   |
| `.badge-danger`    | `.badge-danger`    | Danger badge    |
| `.badge-warning`   | `.badge-warning`   | Warning badge   |
| `.badge-info`      | `.badge-info`      | Info badge      |
| `.badge-pill`      | `.badge-pill`      | Pill badge      |

## Accessibility Features

- WCAG AA compliant color contrasts
- Keyboard navigation support
- Screen reader friendly markup
- Focus indicators on interactive elements
- Semantic HTML structure
- ARIA labels where needed

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Customization

### Colors

Modify the CSS variables in `main.css` to change the color scheme:

```css
:root {
  --primary-color: #your-color;
  --secondary-color: #your-color;
  /* ... */
}
```

### Typography

Adjust font settings:

```css
:root {
  --font-family: "Your Font", sans-serif;
  --font-size-base: 1rem;
  /* ... */
}
```

### Spacing

Modify spacing scale:

```css
:root {
  --spacer: 1rem;
  --spacer-sm: 0.5rem;
  /* ... */
}
```

## Preview Pages

The `previews/` directory contains HTML snippets for:

- `Login.html` - Login page
- `Dashboard.html` - Student dashboard
- `CoursePage.html` - Course details page
- `QuizPage.html` - Quiz interface
- `Assignments.html` - Assignments list
- `AdminUserList.html` - Admin user management

These previews use placeholder content and demonstrate the new styling system.

## Troubleshooting

### Common Issues

1. **Styles not loading**: Check file paths and ensure CSS files are accessible
2. **Layout broken**: Verify container and grid classes are applied correctly
3. **Colors not updating**: Clear browser cache after modifying CSS variables
4. **Responsive issues**: Test on different screen sizes and check media queries

### Fallback Support

If you need to maintain some Bootstrap functionality, you can include Bootstrap after the custom styles:

```html
<link rel="stylesheet" href="main.css" />
<link rel="stylesheet" href="bootstrap-compat.css" />
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
/>
```

This will use custom styles where available and fall back to Bootstrap for unmapped classes.

## Contributing

When adding new components:

1. Add styles to `main.css` for new components
2. Update `bootstrap-compat.css` if overriding Bootstrap classes
3. Document new classes in this README
4. Test across different browsers and screen sizes
5. Ensure accessibility compliance

## License

This design system is provided as-is for use in the LMS project.
